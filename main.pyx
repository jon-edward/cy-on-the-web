# cython: language_level=3

# Run JS code in the browser.
cdef extern void emscripten_run_script(char *script)


def print_str_py(s):
    print("Received string:", s)

cdef public void print_str(str s):
    print_str_py(s)

cdef public void do_nothing(str s): pass

cdef void main():
    emscripten_run_script("console.log('Hello, world!')")
    print_str("Hello, world!")

if __name__ == "__main__":
    main()
