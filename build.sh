export EMSDK_QUIET=1
source ./emsdk/emsdk_env.sh

out_dir=$(pwd)/out

rm -rf $out_dir
mkdir -p $out_dir

cython --embed ./main.pyx

cpython_dir=$(pwd)/cpython
builddir=$cpython_dir/builddir/emscripten-browser

if [[ -z "${IS_PAGES_BUILD}" ]]; then
  extra_flags=(-O1 -Wall -Wextra -Werror -g)
else
  extra_flags=(-Os)
fi

emcc main.c -o $out_dir/index.html \
    -I$cpython_dir/Include/ \
    -I$(pwd) \
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
    -s "EXPORTED_RUNTIME_METHODS=['ccall', 'cwrap', 'FS', 'HEAP8', 'callMain']" \
    -s "EXPORTED_FUNCTIONS=['_main', '_step_canvas']" \
    -s "ALLOW_MEMORY_GROWTH=1" \
    -s "INITIAL_MEMORY=16MB" \
    ${extra_flags[@]}

cp -r $builddir/usr $out_dir/usr
