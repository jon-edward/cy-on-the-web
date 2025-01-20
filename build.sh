export EMSDK_QUIET=1
source ./emsdk/emsdk_env.sh

out_dir=$(pwd)/out

rm -rf $out_dir
mkdir -p $out_dir

cython --embed ./main.pyx

cpython_dir=$(pwd)/cpython
builddir=$cpython_dir/builddir/emscripten-browser

emcc main.c -o $out_dir/index.html \
    -I$cpython_dir/Include/ \
    -I$builddir/ \
    -L$builddir/ \
    -L$builddir/Modules/_decimal/libmpdec/ \
    -L$builddir/Modules/expat/ \
    -L$builddir/Modules/_hacl/ \
    -lpython3.12 \
    -lmpdec \
    -lexpat \
    -lHacl_Hash_SHA2 \
    -lbz2 \
    -lz \
    -lsqlite3 \
    --shell-file ./shell.html \
    -s "EXPORTED_RUNTIME_METHODS=['ccall', 'cwrap', 'FS', 'HEAP8']" \
    -s "EXPORTED_FUNCTIONS=['_main', '_do_nothing', '_print_str']" \
    -s "ALLOW_MEMORY_GROWTH=1" \
    -s "WASM=1" \
    -s "INITIAL_MEMORY=16MB" \
    -s "ALLOW_TABLE_GROWTH=1" \
    # -Os

cp -r $builddir/usr $out_dir/usr
