# Makefile
.PHONY: all
all: outputkeeper logger logconv;

logger: logger.c
	gcc -Wall -O2 -o logger logger.c

outputkeeper: outputkeeper.c
	gcc -DHEADER_DT -Wall -O2 -o outputkeeper outputkeeper.c
 
logconv: logconv.c
	gcc -Wall -O2 -o logconv logconv.c

.PHONY: clean
clean:
	rm -f logger logconv
	rm -f test.log*

.PHONY: help
help:
	@echo "bash echodate.sh | logger -f test.log -i 5"
	@echo "bash echodate.sh | outputkeeper -f test.log -i 5"
