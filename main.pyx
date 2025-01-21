# cython: language_level=3

"""
This is a simple example script that demonstrates how to use Cython 
in WebAssembly to create a canvas and write text to it.

The main function is called when the page is loaded, and the JS 
environment should call the step_canvas function to request a new frame.

This can be done much easier using just JS, but this gives you an example to 
work off of if you want to get started with Cython in the browser.
"""

from libc.stdio cimport snprintf
from libc.stdlib cimport free, malloc

cdef extern from "util.h":
    cdef void create_canvas(int width, int height)
    cdef void clear_canvas(int r, int g, int b, int a)
    cdef void write_text_on_canvas(int x, int y, const char *text)

cdef struct ModuleState:
    int step_count

# A struct to hold the global state
cdef ModuleState global_state = ModuleState(0)

cdef int abs(int x):
    return x if x >= 0 else -x

cdef public void step_canvas():
    """
    The step_canvas function should be called at every frame, and fills the canvas 
    with a color that modulates with the current step count and a step counter.
    """

    global_state.step_count += 1

    cdef size_t max_str_size = sizeof(char) * 64

    cdef char *message = <char *>malloc(max_str_size)
    snprintf(message, max_str_size, "Step count: %d", global_state.step_count)

    clear_canvas(
        abs((global_state.step_count % 512) - 256), 
        abs(((global_state.step_count + 170) % 512) - 256),
        abs(((global_state.step_count + 340) % 512) - 256), 255)

    write_text_on_canvas(10, 20, message)
    free(message)

cdef void main():
    print("The main function was called, creating the canvas.")
    create_canvas(800, 200)

if __name__ == "__main__":
    main()
