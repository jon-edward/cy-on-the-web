/*
    This file consists of C functions that serve as utilities for Cython.
    It's often nicer to use Emscripten macros as intended instead of as Cython functions.
*/

#include <emscripten.h>

void create_canvas(int width, int height)
{
    EM_ASM({
        var canvas = document.createElement('canvas');
        canvas.width = $0;
        canvas.height = $1;
        document.body.appendChild(canvas); }, width, height);
}

void clear_canvas(int r, int g, int b, int a)
{
    EM_ASM({
        const canvas = document.getElementsByTagName('canvas')[0];
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = `rgba(${$0}, ${$1}, ${$2}, ${$3})`;
        ctx.fillRect(0, 0, canvas.width, canvas.height); }, r, g, b, a);
}

void write_text_on_canvas(int x, int y, const char *text)
{
    EM_ASM({
        const canvas = document.getElementsByTagName('canvas')[0];
        const ctx = canvas.getContext('2d');
        ctx.font = '20px Arial';
        ctx.fillStyle = 'black';
        ctx.fillText(UTF8ToString($0), $1, $2); }, text, x, y);
}
