import argparse
from pipreqs import pipreqs
import json

mapping = {
    'mnist': 'python-mnist',
    'skimage': 'scikit-image',
}

def main(path, extra_ignore_dirs):
    # Get all potential imports.
    candidates = pipreqs.get_all_imports(path, extra_ignore_dirs=extra_ignore_dirs, ignore_errors=True)

    if len(candidates) == 0:
        print(json.dumps([]))
        return

    # Get imports that can be found locally.
    # Note: although the pipreqs package gets the mapping first it seems that
    # `get_import_local` requires the names without the mapping. Must be a bug.
    local = pipreqs.get_import_local(candidates)

    # Now get the mapping (e.g. bs4 -> beatifulsoup4)
    # Start with our own custom mapping
    candidates = [mapping[name.lower()] if name.lower() in mapping else name for name in candidates]
    # pipreqs mapping
    candidates = pipreqs.get_pkg_names(candidates)

    # Compute the diff
    difference = [x for x in candidates
      if x.lower() not in [z['name'].lower() for z in local]]

    # To get the version we need to call pypi but that's too risky to do
    # on every call so, for now, we go with the latest version.
    # See https://goo.gl/3nJLMq
    print(json.dumps([{'version': '*', 'name': name} for name in difference]))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Find all external python imports in a directory')
    parser.add_argument('path', metavar='dir', type=str, help='codebase directory')
    parser.add_argument('--ignore', type=str, help='comma-seperated dirs to ignore')

    args = parser.parse_args()
    extra_ignore_dirs = args.ignore

    if extra_ignore_dirs:
        extra_ignore_dirs = extra_ignore_dirs.split(',')
    else:
        extra_ignore_dirs = []

    main(args.path, extra_ignore_dirs)
