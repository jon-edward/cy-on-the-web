# cython: language_level=3

# If a function needs to use Python functions or types and is exposed to wasm it must have an api
# declaration. 
# 
# At least one member needs to be public to get header file generation (required).
cdef public int _triggers_header_generation = 0

from timeit import timeit

cdef api void _exec_python(const char *code):
    """
    Executes the Python code.
    """
    exec(code)

cdef api void _exec_python_file(const char *filename):
    """
    Reads the Python code from a file and executes it.
    """
    with open(filename) as f:
        exec(f.read())

def sum_of_squares_py(n: int) -> float:
    total = 0
    for i in range(n):
        total += i ** 2
    return total

cdef sum_of_squares_cy(int n):
    cdef int i
    cdef int total = 0
    for i in range(n):
        total += i ** 2
    return total

iterations = 50000
up_to = 1000

print(f"=== Running sum of squares up to {up_to} with {iterations} iterations ===")
print(f"Python (def, no typing): {timeit(lambda: sum_of_squares_py(up_to), number=iterations, globals=globals()):.3f}s")
print(f"Cython (cdef): {timeit(lambda: sum_of_squares_cy(up_to), number=iterations, globals=globals()):.3f}s")

print("\nTry executing Python code from the JS console using: \nModule.ccall('exec_python', null, ['string'], ['print(\"Hello World!\")'])")

