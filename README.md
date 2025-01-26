# cy-on-the-web

A proof of concept for compiling Cython to WASM.

# Usage

After cloning this repo, pull git submodules:

```shell
git submodule update --init --recursive --depth 1
```

Next, build the Python interpreter with Emscripten (this will take a long time,
you only need to do this once):

```shell
source ./build_cpython_for_wasm.sh
```

To build `./out`, run:

```shell
make
```

Once the build is complete, you can start a server from `./out`:

```shell
python3 -m http.server --directory ./out
```

Then navigate to `http://localhost:8000` in your browser.
