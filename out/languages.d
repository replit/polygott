# A file with Makefile dependencies

# Dependencies between language stamps
build/stamps/build-layer-phase2-ballerina: build/stamps/build-layer-phase2-java
build/stamps/build-layer-phase2-cpp: build/stamps/build-layer-phase2-c
build/stamps/build-layer-phase2-cpp11: build/stamps/build-layer-phase2-c
build/stamps/build-layer-phase2-elixir: build/stamps/build-layer-phase2-erlang
build/stamps/build-layer-phase2-enzyme: build/stamps/build-layer-phase2-nodejs
build/stamps/build-layer-phase2-flow: build/stamps/build-layer-phase2-nodejs
build/stamps/build-layer-phase2-fsharp: build/stamps/build-layer-phase2-csharp
build/stamps/build-layer-phase2-gatsbyjs: build/stamps/build-layer-phase2-nodejs
build/stamps/build-layer-phase2-jest: build/stamps/build-layer-phase2-nodejs
build/stamps/build-layer-phase2-nextjs: build/stamps/build-layer-phase2-nodejs
build/stamps/build-layer-phase2-pygame: build/stamps/build-layer-phase2-python3
build/stamps/build-layer-phase2-pyxel: build/stamps/build-layer-phase2-python3
build/stamps/build-layer-phase2-quil: build/stamps/build-layer-phase2-python3
build/stamps/build-layer-phase2-react_native: build/stamps/build-layer-phase2-jest
build/stamps/build-layer-phase2-reactjs: build/stamps/build-layer-phase2-nodejs
build/stamps/build-layer-phase2-reactts: build/stamps/build-layer-phase2-nodejs
build/stamps/build-layer-phase2-scala: build/stamps/build-layer-phase2-java

# Dependencies between language manifests for diffs.
build/diffs/phase2-assembly.tar.bz2: extra/manifest_tool.py build/manifests/phase2-assembly.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-assembly" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-assembly.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-java.tar.bz2: extra/manifest_tool.py build/manifests/phase2-java.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-java" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-java.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-ballerina.tar.bz2: extra/manifest_tool.py build/manifests/phase2-ballerina.json.gz build/manifests/phase2-java.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-ballerina" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-java.json.gz \
			--manifest=/mnt/manifests/phase2-ballerina.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-bash.tar.bz2: extra/manifest_tool.py build/manifests/phase2-bash.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-bash" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-bash.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-c.tar.bz2: extra/manifest_tool.py build/manifests/phase2-c.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-c" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-c.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-clisp.tar.bz2: extra/manifest_tool.py build/manifests/phase2-clisp.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-clisp" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-clisp.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-clojure.tar.bz2: extra/manifest_tool.py build/manifests/phase2-clojure.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-clojure" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-clojure.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-cpp.tar.bz2: extra/manifest_tool.py build/manifests/phase2-cpp.json.gz build/manifests/phase2-c.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-cpp" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-c.json.gz \
			--manifest=/mnt/manifests/phase2-cpp.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-cpp11.tar.bz2: extra/manifest_tool.py build/manifests/phase2-cpp11.json.gz build/manifests/phase2-c.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-cpp11" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-c.json.gz \
			--manifest=/mnt/manifests/phase2-cpp11.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-crystal.tar.bz2: extra/manifest_tool.py build/manifests/phase2-crystal.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-crystal" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-crystal.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-csharp.tar.bz2: extra/manifest_tool.py build/manifests/phase2-csharp.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-csharp" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-csharp.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-d.tar.bz2: extra/manifest_tool.py build/manifests/phase2-d.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-d" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-d.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-dart.tar.bz2: extra/manifest_tool.py build/manifests/phase2-dart.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-dart" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-dart.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-deno.tar.bz2: extra/manifest_tool.py build/manifests/phase2-deno.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-deno" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-deno.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-elisp.tar.bz2: extra/manifest_tool.py build/manifests/phase2-elisp.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-elisp" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-elisp.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-erlang.tar.bz2: extra/manifest_tool.py build/manifests/phase2-erlang.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-erlang" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-erlang.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-elixir.tar.bz2: extra/manifest_tool.py build/manifests/phase2-elixir.json.gz build/manifests/phase2-erlang.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-elixir" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-erlang.json.gz \
			--manifest=/mnt/manifests/phase2-elixir.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-nodejs.tar.bz2: extra/manifest_tool.py build/manifests/phase2-nodejs.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-nodejs" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-nodejs.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-enzyme.tar.bz2: extra/manifest_tool.py build/manifests/phase2-enzyme.json.gz build/manifests/phase2-nodejs.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-enzyme" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-nodejs.json.gz \
			--manifest=/mnt/manifests/phase2-enzyme.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-express.tar.bz2: extra/manifest_tool.py build/manifests/phase2-express.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-express" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-express.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-flow.tar.bz2: extra/manifest_tool.py build/manifests/phase2-flow.json.gz build/manifests/phase2-nodejs.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-flow" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-nodejs.json.gz \
			--manifest=/mnt/manifests/phase2-flow.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-forth.tar.bz2: extra/manifest_tool.py build/manifests/phase2-forth.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-forth" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-forth.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-fortran.tar.bz2: extra/manifest_tool.py build/manifests/phase2-fortran.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-fortran" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-fortran.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-fsharp.tar.bz2: extra/manifest_tool.py build/manifests/phase2-fsharp.json.gz build/manifests/phase2-csharp.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-fsharp" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-csharp.json.gz \
			--manifest=/mnt/manifests/phase2-fsharp.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-gatsbyjs.tar.bz2: extra/manifest_tool.py build/manifests/phase2-gatsbyjs.json.gz build/manifests/phase2-nodejs.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-gatsbyjs" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-nodejs.json.gz \
			--manifest=/mnt/manifests/phase2-gatsbyjs.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-go.tar.bz2: extra/manifest_tool.py build/manifests/phase2-go.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-go" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-go.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-guile.tar.bz2: extra/manifest_tool.py build/manifests/phase2-guile.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-guile" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-guile.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-haskell.tar.bz2: extra/manifest_tool.py build/manifests/phase2-haskell.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-haskell" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-haskell.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-haxe.tar.bz2: extra/manifest_tool.py build/manifests/phase2-haxe.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-haxe" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-haxe.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-jest.tar.bz2: extra/manifest_tool.py build/manifests/phase2-jest.json.gz build/manifests/phase2-nodejs.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-jest" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-nodejs.json.gz \
			--manifest=/mnt/manifests/phase2-jest.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-julia.tar.bz2: extra/manifest_tool.py build/manifests/phase2-julia.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-julia" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-julia.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-kotlin.tar.bz2: extra/manifest_tool.py build/manifests/phase2-kotlin.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-kotlin" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-kotlin.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-love2d.tar.bz2: extra/manifest_tool.py build/manifests/phase2-love2d.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-love2d" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-love2d.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-lua.tar.bz2: extra/manifest_tool.py build/manifests/phase2-lua.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-lua" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-lua.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-mercury.tar.bz2: extra/manifest_tool.py build/manifests/phase2-mercury.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-mercury" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-mercury.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-nextjs.tar.bz2: extra/manifest_tool.py build/manifests/phase2-nextjs.json.gz build/manifests/phase2-nodejs.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-nextjs" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-nodejs.json.gz \
			--manifest=/mnt/manifests/phase2-nextjs.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-nim.tar.bz2: extra/manifest_tool.py build/manifests/phase2-nim.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-nim" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-nim.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-objective-c.tar.bz2: extra/manifest_tool.py build/manifests/phase2-objective-c.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-objective-c" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-objective-c.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-ocaml.tar.bz2: extra/manifest_tool.py build/manifests/phase2-ocaml.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-ocaml" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-ocaml.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-pascal.tar.bz2: extra/manifest_tool.py build/manifests/phase2-pascal.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-pascal" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-pascal.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-php.tar.bz2: extra/manifest_tool.py build/manifests/phase2-php.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-php" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-php.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-powershell.tar.bz2: extra/manifest_tool.py build/manifests/phase2-powershell.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-powershell" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-powershell.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-prolog.tar.bz2: extra/manifest_tool.py build/manifests/phase2-prolog.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-prolog" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-prolog.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-python3.tar.bz2: extra/manifest_tool.py build/manifests/phase2-python3.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-python3" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-python3.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-pygame.tar.bz2: extra/manifest_tool.py build/manifests/phase2-pygame.json.gz build/manifests/phase2-python3.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-pygame" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-python3.json.gz \
			--manifest=/mnt/manifests/phase2-pygame.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-python.tar.bz2: extra/manifest_tool.py build/manifests/phase2-python.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-python" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-python.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-pyxel.tar.bz2: extra/manifest_tool.py build/manifests/phase2-pyxel.json.gz build/manifests/phase2-python3.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-pyxel" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-python3.json.gz \
			--manifest=/mnt/manifests/phase2-pyxel.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-quil.tar.bz2: extra/manifest_tool.py build/manifests/phase2-quil.json.gz build/manifests/phase2-python3.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-quil" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-python3.json.gz \
			--manifest=/mnt/manifests/phase2-quil.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-raku.tar.bz2: extra/manifest_tool.py build/manifests/phase2-raku.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-raku" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-raku.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-react_native.tar.bz2: extra/manifest_tool.py build/manifests/phase2-react_native.json.gz build/manifests/phase2-jest.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-react_native" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-jest.json.gz \
			--manifest=/mnt/manifests/phase2-react_native.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-reactjs.tar.bz2: extra/manifest_tool.py build/manifests/phase2-reactjs.json.gz build/manifests/phase2-nodejs.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-reactjs" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-nodejs.json.gz \
			--manifest=/mnt/manifests/phase2-reactjs.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-reactts.tar.bz2: extra/manifest_tool.py build/manifests/phase2-reactts.json.gz build/manifests/phase2-nodejs.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-reactts" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-nodejs.json.gz \
			--manifest=/mnt/manifests/phase2-reactts.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-rlang.tar.bz2: extra/manifest_tool.py build/manifests/phase2-rlang.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-rlang" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-rlang.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-ruby.tar.bz2: extra/manifest_tool.py build/manifests/phase2-ruby.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-ruby" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-ruby.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-rust.tar.bz2: extra/manifest_tool.py build/manifests/phase2-rust.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-rust" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-rust.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-scala.tar.bz2: extra/manifest_tool.py build/manifests/phase2-scala.json.gz build/manifests/phase2-java.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-scala" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase2-java.json.gz \
			--manifest=/mnt/manifests/phase2-scala.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-sqlite.tar.bz2: extra/manifest_tool.py build/manifests/phase2-sqlite.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-sqlite" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-sqlite.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-swift.tar.bz2: extra/manifest_tool.py build/manifests/phase2-swift.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-swift" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-swift.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-tcl.tar.bz2: extra/manifest_tool.py build/manifests/phase2-tcl.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-tcl" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-tcl.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-webassembly.tar.bz2: extra/manifest_tool.py build/manifests/phase2-webassembly.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-webassembly" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-webassembly.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-wren.tar.bz2: extra/manifest_tool.py build/manifests/phase2-wren.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-wren" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-wren.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"

build/diffs/phase2-tools.tar.bz2: extra/manifest_tool.py build/manifests/phase2-tools.json.gz build/manifests/phase1.5.json.gz | build/diffs/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py,ro" \
		--mount "type=bind,src=$(PWD)/build/manifests,target=/mnt/manifests,ro" \
		"polygott:phase2-tools" \
		/usr/bin/manifest_tool.py diff \
			--parent-manifest=/mnt/manifests/phase1.5.json.gz \
			--manifest=/mnt/manifests/phase2-tools.json.gz > "$@.tmp"
	mv "$@.tmp" "$@"
