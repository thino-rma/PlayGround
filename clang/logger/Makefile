# Makefile
.PHONY: all
all: outputkeeper outlog dumb logger logconv;

logger: logger.c
	gcc -Wall -O2 -o logger logger.c

outputkeeper: outputkeeper.c
	# gcc -DDEBUG -DHEADER_DT -Wall -O2 -o outputkeeper outputkeeper.c
	# gcc -DHEADER_DT -Wall -O2 -o outputkeeper outputkeeper.c
	gcc -DHEADER_DT -Wall -O2 -o outputkeeper outputkeeper.c
 
outlog: outlog.c
	# gcc -DDEBUG -Wall -O2 -o outlog outlog.c
	gcc -Wall -O2 -o outlog outlog.c

dumb: dumb.c
	# gcc -DDEBUG -Wall -O2 -o dumb dumb.c
	gcc -Wall -O2 -o dumb dumb.c

logconv: logconv.c
	gcc -Wall -O2 -o logconv logconv.c

.PHONY: clean
clean:
	rm -f logger logconv outputkeeper
	rm -f test.log*

.PHONY: help
help:
	@echo "bash echodate.sh | logger -f test.log -i 30"
	@echo "bash echodate.sh | outputkeeper -f test.log -i 30"
	@echo "bash echodate.sh | outputkeeper -f test.log -p ok.pid -i 30 -m META"
