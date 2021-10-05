#!/usr/bin/env python3
"""Tool to help splitting and splicing docker image layers.

There are four subcommands:

* `context` creates a Docker build context as a bz2-compressed tarball. This is
  better than letting Docker figure it out because this allows us to filter out
  some things that Docker thinks are important but are not (e.g. mtimes or
  group permission bit changes).
* `create` creates a manifest. this allows intermediate polygott layers to
  self-describe the contents of the container image. By running it on a live
  container, it achieves a very similar goal to `docker image save`, but does
  not emit the whole tarfile and only emit the metadata of the files.
* `diff` dumps the diff of two container images' filesystems, as described by
  their manifests. The diff is a tarball (bz2-compressed) with all the added or
  modified files (deletions are not yet supported!).
* `splice` merges multiple tarball diffs into a single, final image. This is
  achieved by creating a custom Docker build context with a Dockerfile and the
  tarballs, and issuing an `ADD` command that extracts them all in one fell
  swoop. At the end it injects the `ENV` variables and cleans up the ldconfig
  cache.
"""

import argparse
import gzip
import io
import json
import os
import os.path
import re
import stat
import sys
import tarfile

from typing import IO, List, NamedTuple, Optional, Set, Tuple

# These files are always expected to change and/or are injected by the Docker
# runtime.
_IGNORE_PATHS = set((
    '.dockerenv',
    'dev',
    'etc/hosts',
    'etc/ld.so.cache',
    'etc/mtab',
    'etc/resolv.conf',
    'home/runner/.bash_logout',
    'home/runner/.bashrc',
    'home/runner/.profile',
    'mnt/polygott-parent',
    'proc',
    'run/systemd',
    'sys',
    'usr/bin/manifest_tool.py',
    'usr/share/polygott-manifest.json',
    'var/cache/ldconfig/aux-cache',
    'var/lib/dpkg/status',
    'var/lib/dpkg/status-old',
))


def json_serializable(cls):
    """Decorator to make a NamedTuple serializable."""
    def as_dict(self):
        yield {
            name: value
            for name, value in zip(self._fields,
                                   iter(super(cls, self).__iter__()))
        }

    cls.__iter__ = as_dict
    return cls


@json_serializable
class Entry(NamedTuple):
    """Represents a file / directory in a container image."""
    relative_path: str
    ino: int
    size: int
    mode: int
    mtime: int
    uid: int
    gid: int
    link_target: Optional[str] = None

    def is_dir(self) -> bool:
        return stat.S_ISDIR(self.mode)

    def is_link(self) -> bool:
        return stat.S_ISLNK(self.mode)

    def is_regular(self) -> bool:
        return stat.S_ISREG(self.mode)

    def is_equivalent(self, o: Optional['Entry']) -> bool:
        if o is None:
            return False
        if self.is_dir() and o.is_dir():
            return (self.mode, self.uid, self.gid) == (o.mode, o.uid, o.gid)
        if self.is_link() and o.is_link():
            return (self.link_target, self.mode, self.uid,
                    self.gid) == (o.link_target, o.mode, o.uid, o.gid)
        if self.is_regular() and o.is_regular():
            if (self.size, self.mode, self.uid, self.gid) == (o.size, o.mode,
                                                              o.uid, o.gid):
                # There is a high chance that these two entries are equivalent.
                # TODO: Let's check the contents!
                return True
        return self.__eq__(o)


@json_serializable
class Manifest(NamedTuple):
    """Represents the difference between two container images."""
    created: List[Entry] = []
    modified: List[Tuple[Entry, Entry]] = []
    deleted: List[Entry] = []

    @staticmethod
    def load(f: IO) -> 'Manifest':
        if getattr(f, 'name', '/dev/stdin').endswith('.gz'):
            with gzip.GzipFile(fileobj=f, mode='r') as gz:
                raw_manifest = json.load(gz)[0]
        else:
            raw_manifest = json.load(f)[0]
        return Manifest(
            created=[Entry(**entry) for (entry, ) in raw_manifest['created']],
            modified=[(Entry(**parent_entry), Entry(**root_entry))
                      for ((parent_entry, ),
                           (root_entry, )) in raw_manifest['modified']],
            deleted=[Entry(**entry) for (entry, ) in raw_manifest['deleted']],
        )


def _walk(root: str) -> Set[Entry]:
    """Perform a walk of a directory, skipping any mounted filesystems."""
    with open('/proc/self/mounts') as f:
        mountpoints = set(line.split()[1]
                          for line in f.read().strip().split('\n'))

    entries: Set[Entry] = set()
    link_target: Optional[str] = None
    for dirpath, dirnames, filenames in os.walk(root):
        keep_dirnames: List[str] = []
        for dirname in dirnames:
            full_path = os.path.join(dirpath, dirname)
            if full_path in mountpoints:
                continue
            relative_path = os.path.relpath(full_path, root)
            if relative_path in _IGNORE_PATHS:
                continue
            keep_dirnames.append(dirname)
            st = os.lstat(full_path)
            if stat.S_ISLNK(st.st_mode):
                link_target = os.readlink(full_path)
            else:
                link_target = None
            entries.add(
                Entry(
                    relative_path=relative_path,
                    ino=st.st_ino,
                    size=0,
                    mode=st.st_mode,
                    mtime=0,
                    uid=st.st_uid,
                    gid=st.st_gid,
                    link_target=link_target,
                ))
        # Prune any mountpoints from the walk.
        dirnames[:] = keep_dirnames

        for filename in filenames:
            full_path = os.path.join(dirpath, filename)
            relative_path = os.path.relpath(full_path, root)
            if relative_path in _IGNORE_PATHS:
                continue
            st = os.lstat(full_path)
            if stat.S_ISLNK(st.st_mode):
                link_target = os.readlink(full_path)
            else:
                link_target = None
            entries.add(
                Entry(
                    relative_path=relative_path,
                    ino=st.st_ino,
                    size=st.st_size,
                    mode=st.st_mode,
                    mtime=int(st.st_mtime),
                    uid=st.st_uid,
                    gid=st.st_gid,
                    link_target=link_target,
                ))
    return entries


def create(args: argparse.Namespace) -> None:
    """Write a manifest JSON to stdout.

    The created manifest file contains a record of all files in the container's
    rootfs.  This manifest can then be used to diff against other container
    images.
    """
    manifest = Manifest(created=sorted(_walk('/'),
                                       key=lambda e: e.relative_path), )
    print(json.dumps(manifest, indent='  '))


def diff(args: argparse.Namespace) -> None:
    """Dump the filesystem diff between two images into a tarball.

    This is similar to what Docker does with layer diffing, except this
    coalesces several physical layers into a logical one, and does not depend
    on undocumented features or implementation details of how the layers are
    stored in disk.

    The bz2-compressed tarball will be written to stdout.
    """

    parent_entries = {
        e.relative_path: e
        for e in Manifest.load(args.parent_manifest_file).created
    }
    child_entries = {
        e.relative_path: e
        for e in Manifest.load(args.child_manifest_file).created
    }

    manifest = Manifest()

    # Sort the entries so that any directories are created before their
    # contents.
    for relative_path, entry in sorted(child_entries.items()):
        parent_entry = parent_entries.get(relative_path)
        if not parent_entry or entry.is_equivalent(parent_entry):
            continue
        manifest.modified.append((parent_entry, entry))
    for relative_path, entry in sorted(child_entries.items()):
        if relative_path in parent_entries:
            continue
        manifest.created.append(entry)
    # Sort in the reverse order so that any files are deleted before their
    # directories.
    for relative_path, entry in sorted(parent_entries.items(), reverse=True):
        if relative_path in child_entries:
            continue
        manifest.deleted.append(entry)

    with tarfile.open(mode='w|bz2', fileobj=sys.stdout.buffer) as tar:
        for entry in ([root_entry for _, root_entry in manifest.modified] +
                      manifest.created):
            tar.add(os.path.join('/', entry.relative_path), recursive=False)


def splice(args: argparse.Namespace) -> None:
    """Splice multiple tarball diffs into a single Docker build context.

    Instead of having Docker apply the changes for all the layers one by one
    (the strategy used by DockerMake, which is super slow), or building it ALL
    at the same time (the strategy used by expressing all dependencies in
    BuildKit, which ends up OOMing), we can do the expensive part of creating
    individual layer diffs upfront, and then just stitch the deltas all at
    once.

    This grabs a list of image diffs (as compressed tarballs) and a mapping of
    the diffs to their parent image (to be able to stitch them in a consistent
    order) and creates a Docker build context with a Dockerfile and the diffs,
    and generate the necessary `ADD` command to extract all the payloads in a
    single layer.

    The Docker build context will be emitted as a single, uncompressed tarball,
    which will be written to stdout.
    """

    language_parents = json.load(args.languages_json)['parents']

    visited: Set[str] = set(('phase1.5', 'phase2-tools'))
    ordered_languages: List[str] = []

    def _visit_language(language: str) -> None:
        if language in visited:
            return
        if language in language_parents:
            _visit_language(language_parents[language])
        visited.add(language)
        ordered_languages.append(language)

    # Emit the languages in the topological sort (using lexicographic order for
    # breaking ties) of the dependency tree.
    for language in sorted(args.languages):
        _visit_language(f'phase2-{language}')

    # This must always come last.
    visited.remove('phase2-tools')
    _visit_language('phase2-tools')

    tarballs = [f'{language}.tar.bz2' for language in ordered_languages]

    with tarfile.open(mode='w|', fileobj=sys.stdout.buffer) as tar:
        dockerfile_contents = args.dockerfile.read().replace(
            '#ADD#',
            f'ADD {" ".join(tarballs)} /',
        ).encode('utf-8')
        dockerfile = tarfile.TarInfo('Dockerfile')
        dockerfile.size = len(dockerfile_contents)
        dockerfile.mode = 0o644
        dockerfile.type = tarfile.REGTYPE

        tar.addfile(dockerfile, io.BytesIO(dockerfile_contents))

        for tarball in tarballs:
            tar.add(os.path.join(args.tarball_directory, tarball),
                    arcname=os.path.basename(tarball))


def context(args: argparse.Namespace) -> None:
    """Generate a VERY stable Docker build context.

    In particular, this clears out mtimes for all the files and homogenizes the
    permission bits of the files, so that Docker does not use that information
    against us when deciding when not to cache.

    The context is created by creating a tarball with the Dockerfile with the
    name `Dockerfile` at the root, and then reads the `.dockerignore` file to
    figure out what files to include in the context. Note: `.dockerignore` must
    be written in an allow-list fashion: denying everything with a `*` as the
    first entry and then exluding an explicit list of files that you actually
    want in the context.

    This writes a bz2-compressed tarball with the contents of the build context
    to stdout.
    """
    def _sub_globs(match: re.Match) -> str:
        if match.group(0) == '*':
            return '[^/]*'
        elif match.group(0) == '**/':
            return '(?:.*/)?'
        assert False, match

    glob_re = re.compile(r'(^\*\*/)|((?<=/)\*\*/)|((?<!\*)\*(?!\*))')
    regexps: List[re.Pattern] = []
    for line in args.dockerignore:
        if not line.startswith('!'):
            continue
        pattern = glob_re.sub(_sub_globs, line.strip().lstrip('!'))
        regexps.append(re.compile(f'^{pattern}$'))

    added_files: Set[str] = set()
    for root, _, filenames in os.walk('.'):
        if root.startswith('./'):
            root = root[2:]

        for filename in filenames:
            filepath = os.path.join(root, filename)
            if not any(r.fullmatch(filepath) for r in regexps):
                continue
            added_files.add(filepath)
            while '/' in filepath:
                filepath = os.path.dirname(filepath)
                added_files.add(filepath)

    with tarfile.open(mode='w|bz2', fileobj=sys.stdout.buffer) as tar:
        dockerfile_contents = args.dockerfile.read().encode('utf-8')
        tarinfo = tarfile.TarInfo('Dockerfile')
        tarinfo.size = len(dockerfile_contents)
        tarinfo.mode = 0o644
        tarinfo.type = tarfile.REGTYPE

        tar.addfile(tarinfo, fileobj=io.BytesIO(dockerfile_contents))

        for filename in sorted(added_files):
            st = os.stat(filename)
            tarinfo = tarfile.TarInfo(filename)
            if stat.S_ISDIR(st.st_mode):
                tarinfo.mode = 0o755
                tarinfo.type = tarfile.DIRTYPE
                tar.addfile(tarinfo)
            else:
                tarinfo.mode = st.st_mode & 0o755
                tarinfo.size = st.st_size
                tarinfo.type = tarfile.REGTYPE
                with open(filename, 'rb') as f:
                    tar.addfile(tarinfo, fileobj=f)


def _main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    subparsers = parser.add_subparsers(help='command', dest='command')

    parser_create = subparsers.add_parser('create',
                                          help='Create a manifest file')

    parser_diff = subparsers.add_parser(
        'diff',
        help=('Write a tarball (bz2-compressed) with the '
              'contents of the changed files to stdout'))
    parser_diff.add_argument('--parent-manifest',
                             dest='parent_manifest_file',
                             metavar='MANIFEST_FILE',
                             type=argparse.FileType('rb'),
                             required=True,
                             help='The path of the parent manifest file')
    parser_diff.add_argument('--manifest',
                             dest='child_manifest_file',
                             metavar='MANIFEST_FILE',
                             type=argparse.FileType('rb'),
                             required=True,
                             help='The path of the manifest file')

    parser_splice = subparsers.add_parser(
        'splice',
        help=('Write a tarball (uncompressed) with the '
              'contents of a Docker build context to stdout'))
    parser_splice.add_argument(
        '--languages-json',
        default='out/languages.json',
        type=argparse.FileType('r'),
        help='The path to the languages.json file (with dependency information)'
    )
    parser_splice.add_argument('--dockerfile',
                               default='out/Dockerfile.splice',
                               type=argparse.FileType('r'),
                               help='The path of the splicing Dockerfile')
    parser_splice.add_argument(
        '--tarball-directory',
        default='build/diffs',
        type=str,
        help='The path of the directory where the tarballs are located')
    parser_splice.add_argument('languages',
                               metavar='LANGAUGE',
                               nargs='+',
                               type=str,
                               help='The name of a language')

    parser_context = subparsers.add_parser(
        'context',
        help=('Write a tarball (bz2-compressed) with the '
              'contents of the main Docker build context to stdout'))
    parser_context.add_argument('--dockerfile',
                                default='out/Dockerfile',
                                type=argparse.FileType('r'),
                                help='The path of the Dockerfile')
    parser_context.add_argument('--dockerignore',
                                default='.dockerignore',
                                type=argparse.FileType('r'),
                                help='The path of the .dockerignore file')

    args = parser.parse_args()

    if args.command == 'create':
        create(args)
    elif args.command == 'diff':
        diff(args)
    elif args.command == 'splice':
        splice(args)
    elif args.command == 'context':
        context(args)
    else:
        raise Exception(f'Unsupported command: {args.command!r}')


if __name__ == '__main__':
    _main()
