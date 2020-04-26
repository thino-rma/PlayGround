# Makefile
.PHONY: all
all: mylogger mylogconv;

mylogger: logger.c
	gcc -Wall -O2 -DDEBUG -o mylogger logger.c

mylogconv: logconv.c
	gcc -Wall -O2 -o mylogconv logconv.c

.PHONY: clean
clean:
	rm -f mylogger mylogconv
	rm -f test.log*

.PHONY: help
help:
	@echo "bash echodate.sh | ./mylogger -f test.log -i 5"
	@echo "./mylogconv < test.log"
