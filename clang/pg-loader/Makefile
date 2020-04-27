# Makefile
.PHONY: all
all: pg-version;

pg-version: pg-version.c
	gcc -Wall -g -O2 -I/usr/include/postgresql -L/usr/lib/x86_64-linux-gnu -o pg-version pg-version.c -lpq
	
