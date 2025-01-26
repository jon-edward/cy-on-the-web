pushd ./emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
popd

export EM_CONFIG=$(pwd)/emsdk/.emscripten
python3 ./cpython/Tools/wasm/wasm_build.py emscripten-browser build
