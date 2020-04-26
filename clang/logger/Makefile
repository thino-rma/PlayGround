# Makefile
.PHONY: all
all: logger logconv;

logger: logger.c
	gcc -Wall -O2 -o mylogger logger.c

logconv: logconv.c
	gcc -Wall -O2 -o logconv logconv.c

.PHONY: clean
clean:
	rm -f logger logconv
	rm -f test.log*

.PHONY: help
help:
	@echo "bash echodate.sh | logger -f test.log -i 5"
