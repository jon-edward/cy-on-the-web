pushd ./emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
popd

export EM_CONFIG=$(pwd)/emsdk/.emscripten

pushd ./cpython
./configure --enable-wasm-dynamic-linking
./configure --with-emscripten-target=browser
python3 ./Tools/wasm/wasm_build.py emscripten-browser build
popd
