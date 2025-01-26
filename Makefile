CC=emcc

CFILES=$(wildcard cy/*.c)

CPYTHON_DIR=cpython
BUILDDIR=$(CPYTHON_DIR)/builddir/emscripten-browser

INC=-I$(CPYTHON_DIR)/Include/ -Icy/ -I$(BUILDDIR)/

LDFLAGS=-L$(BUILDDIR)/ \
	-L$(BUILDDIR)/Modules/_decimal/libmpdec/ \
	-L${BUILDDIR}/Modules/expat/ \
	-L${BUILDDIR}/Modules/_hacl/

LDLIBS=-lpython3.12 \
	-lmpdec \
	-lexpat \
	-lHacl_Hash_SHA2 \
	-lbz2 \
	-lz \
	-lsqlite3

EMFLAGS=--shell-file ./shell.html \
	-s "EXPORTED_RUNTIME_METHODS=['ccall', 'cwrap', 'FS', 'HEAP8']" \
	-s "EXPORTED_FUNCTIONS=['_main', '_exec_python', '_exec_python_file']" \
	-s "ALLOW_MEMORY_GROWTH=1" \
	-s "INITIAL_MEMORY=16MB"

OUT=out

ifeq ($(RELEASE), 1)
	CFLAGS=-Os
else
	CFLAGS=-O1 -Wall -Wextra -g
endif

.PHONY: all
all: out

cy/main.c: cy/main.pyx
	cython cy/main.pyx

out: cy/main.c
	export EMSDK_QUIET=1 \
	source ./emsdk/emsdk_env.sh \
	mkdir -p $(OUT); \
	$(CC) $(INC) $(CFILES) $(LDFLAGS) $(LDLIBS) $(CFLAGS) $(EMFLAGS) -o out/index.html ; \
	cp -r $(BUILDDIR)/usr $(OUT)/usr

.PHONY: clean
clean:
	rm -rf out