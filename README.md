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

To build `./out` after
[activating the Emscripten environment](https://emscripten.org/docs/getting_started/downloads.html#installation-instructions-using-the-emsdk-recommended), run:

```shell
emmake make
```

Once the build is complete, you can start a server from `./out`:

```shell
python3 -m http.server --directory ./out
```

Then navigate to the test server in your browser.
