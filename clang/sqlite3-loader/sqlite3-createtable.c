#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "sqlite3.h"
#include "logstdout.h"

/* be sure to define these in real life... */
#define DATABASE  "./test.sqlite"
#define CREATE_TABLE "CREATE TABLE IF NOT EXISTS TEST (id INTEGER PRIMARY KEY, name TEXT, timestamp TEXT, value INTEGER)"
/* you can use CREATE TABLE  IF NOT EXISTS TEST ... */

int main(void) {
    sqlite3* db;
    int rc = 0;  /* return code */
    int ec = -1; /* exit code   */
    char *sErrMsg = 0;
    __LOG_CLOCK_INIT

    LOG_INFO("Opening database: %s\n", DATABASE);
    rc = sqlite3_open(DATABASE, &db);
    if (rc != SQLITE_OK) {
        LOG_ERROR("Error: %s %s\n", "Could not open db file.", DATABASE);
        ec = 1;
        goto opendb_out;
    }

    /* before starting the transaction */
    rc = sqlite3_exec(db, "PRAGMA cache_size=10000", NULL, NULL, &sErrMsg);
    rc = sqlite3_exec(db, "PRAGMA synchronous = OFF", NULL, NULL, &sErrMsg);
    rc = sqlite3_exec(db, "PRAGMA journal_mode = MEMORY", NULL, NULL, &sErrMsg);
    // sqlite3_exec(db, "PRAGMA journal_mode = OFF", NULL, NULL, &sErrMsg);
    
    __LOG_CLOCK_START
    rc = sqlite3_exec(db, CREATE_TABLE, NULL, NULL, &sErrMsg);
    __LOG_CLOCK_END
    LOG_DEBUG_IF(rc != SQLITE_OK, "sqlite3_exec() rc=%d\n", rc);
    if (rc == SQLITE_OK) {
        LOG_DEBUG_CLOCK("sqlite3_exec()\n");
        LOG_INFO("Created table.\n");
        ec = 0;
    } else {
        if (sErrMsg != NULL) {
            LOG_ERROR("Error: %s\n", sErrMsg);
            sqlite3_free(sErrMsg);
        }
        ec = 2;
    }

opendb_out:
    if ( db ) {
        sqlite3_close(db);
        db = 0;
    }
    return ec;
}

