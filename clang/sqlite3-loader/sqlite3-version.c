/*
 * compile
 *   gcc -Wall -g -O2 -DSQLITE_THREADSAFE=0 -o sqlite3-version sqlite3-version.c sqlite3.c -ldl
 */
#include <stdio.h>
#include <sqlite3.h>

int main(void) {
    printf("SQLite3 lib number version: %d\n", sqlite3_libversion_number());
    printf("SQLite3 version: %s\n", sqlite3_version);
    return 0;
}
