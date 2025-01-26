/**
 * A wrapper script for visible Cython functions.
 * 
 * Simply using public cdef functions will cause segfaults at any usage of Python 
 * functions and types within the below functions, so the entire module needs to be 
 * imported and kept alive.
 */

#include <emscripten.h>
#include "main_api.h"

EMSCRIPTEN_KEEPALIVE
extern void exec_python(char const *code)
{
    _exec_python(code);
}

EMSCRIPTEN_KEEPALIVE
extern void exec_python_file(char const *filename)
{
    _exec_python_file(filename);
}

int main(int argc, char **argv)
{
    (void)argv[0];
    (void)argc;

    // Adds the module to the list of built-in modules.
    if (PyImport_AppendInittab("main", PyInit_main) < 0) {
        return 1;
    }

    Py_Initialize();

    if (import_main() < 0) return 1;

    // Intentionally does not call Py_Finalize()
    return 0;
}