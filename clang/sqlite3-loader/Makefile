# Makefile
.PHONY: all
all: sample sqlite3-version sqlite3-createtable sqlite3-loader;

sqlite3.o:
	gcc -Wall -g -O2 -I${HOME}/usr/include -L${HOME}/usr/lib -c -o sqlite3.o sqlite3.c -lpthread -ldl

sample: sample.c
	gcc -Wall -g -O2 -I${HOME}/usr/include -L${HOME}/usr/lib -o sample sample.c sqlite3.o -lpthread -ldl

sqlite3-version: sqlite3-version.c
	gcc -Wall -g -O2 -I${HOME}/usr/include -L${HOME}/usr/lib -o sqlite3-version sqlite3-version.c sqlite3.o -lpthread -ldl

sqlite3-createtable: sqlite3-createtable.c logstdout.h sqlite3.o
	gcc -Wall -g -O2 -I${HOME}/usr/include -L${HOME}/usr/lib -DLOGSTDOUT -o sqlite3-createtable sqlite3-createtable.c sqlite3.o -lpthread -ldl

sqlite3-loader: sqlite3-loader.c logstdout.h sqlite3.o
	gcc -Wall -g -O2 -I${HOME}/usr/include -L${HOME}/usr/lib -DLOGSTDOUT -o sqlite3-loader sqlite3-loader.c sqlite3.o -lpthread -ldl

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
	rm -f sqlite3-createtable
	rm -f test.sqlite
# 	rm -f sqlite3-loader

.PHONY: help
help:
	@echo "make / make clean"

