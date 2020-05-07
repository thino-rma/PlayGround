.PHONY: init
init:
	python pysort.py init test 2D 1

.PHONY: config
config:
	python pysort.py config test ALL

.PHONY: add
add:
	python pysort.py add test ../tmp/test.csv --skiprows 1

.PHONY: dry
dry:
	python pysort.py add test ../tmp/test.csv --skiprows 1 --dryrun

.Phony: collect
collect:
	python pysort.py collect test -

.PHONY: init2
init2:
	python pysort.py init nyc_data 2h 2

.PHONY: add2
add2:
	python pysort.py add nyc_data ../tmp/nyc_data_rides.csv

.Phony: collect2
collect2:
	python pysort.py collect nyc_data ../tmp/collect.csv

.PHONY: clean
clean:
	rm -rf ./test


