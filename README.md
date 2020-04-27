# PlayGround
Miscellaneous code

- 2020/04/27
  - clang/pg-loader/pg-loader.c
  - clang/pg-loader/pg-version.c
  - clang/sqlite3-loader/sqlite3-loader.c
  - clang/sqlite3-loader/sqlite3-createtable.c
  - clang/sqlite3-loader/sqlite3-version.c
  - performance comparison
    environment: VirutalBox Ubuntu18.04 CPU 4, MEM 4GB
    | method | result |
    |:-------|-------:|
    |psql CSV LOAD command  | 60,900records/sec|
    |pg-loader inserts      |  5,600records/sec|
    |sqlite3 import command |117,000records/sec|
    |sqlite3-loader inserts |150,000records/sec|
- 2020/04/16
  - clang/logger/logger.c [Updarted on 2020/04/26]
  - ~~clang/logger/logconv.c~~ [Deleted on 2020/04/26]

