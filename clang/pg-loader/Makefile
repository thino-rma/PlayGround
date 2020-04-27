# Makefile
.PHONY: all
all: pg-version pg-loader;

pg-version: pg-version.c
	gcc -Wall -g -O2 -I/usr/include/postgresql -L/usr/lib/x86_64-linux-gnu -o pg-version pg-version.c -lpq
	
pg-loader: pg-loader.c logstdout.h
	gcc -Wall -g -O2 -I/usr/include/postgresql -L/usr/lib/x86_64-linux-gnu -DLOGSTDOUT -o pg-loader pg-loader.c -lpq
	
