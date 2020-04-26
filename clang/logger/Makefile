# Makefile
.PHONY: all
all: mylogger;

mylogger: logger.c
	gcc -Wall -O2 -o mylogger logger.c

.PHONY: clean
clean:
	rm -f mylogger
	rm -f test.log*

.PHONY: help
help:
	@echo "bash echodate.sh | ./mylogger -f test.log -i 5"
