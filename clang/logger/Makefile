# Makefile
.PHONY: all
all: logger logconv

logger: logger.c
	gcc -Wall -O2 -o logger logger.c
logconv: logconv.c
	gcc -Wall -O2 -o logconv logconv.c

.PHONY: clean
clean:
	rm -f logger logconv
