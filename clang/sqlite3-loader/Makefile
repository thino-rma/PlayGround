# Makefile
.PHONY: all
all: sample sqlite3-version sqlite3-loader;

sample: sample.c
	gcc -Wall -g -O2 -I${HOME}/usr/include -L${HOME}/usr/lib -DSQLITE_THREADSAFE=0 -o sample sample.c sqlite3.c -ldl

sqlite3-version: sqlite3-version.c
	gcc -Wall -g -O2 -I${HOME}/usr/include -L${HOME}/usr/lib -DSQLITE_THREADSAFE=0 -o sqlite3-version sqlite3-version.c sqlite3.c -ldl

# sqlite3-loader: main.c
# 	gcc -Wall -g -O2 -I${HOME}/usr/include -L${HOME}/usr/lib -o sqlite3-loader main.c sqlite3.c -lpthread -ldl

# put '-lpthread -ldl' after '*.c' source files. 
# The pthreads library is needed to make SQLite threadsafe. 
# But we could instruct SQLite to build in a non-threadsafe mode
# and thereby omit the pthreads library: -DSQLITE_THREADSAFE=0
# if you need pthread library, install libpthread-stubs0-dev package. 
#
#   $ sudo apt install libpthread-stubs0-dev
#

.PHONY: clean
clean:
	rm -f sample
	rm -f sqlite3-version
# 	rm -f sqlite3-loader

.PHONY: help
help:
	@echo "make / make clean"

