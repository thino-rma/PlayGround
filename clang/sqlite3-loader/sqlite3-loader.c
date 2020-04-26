#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "sqlite3.h"
#include "logstdout.h"

/* be sure to define these in real life... */
#define DATABASE  "./test.sqlite"
#define CREATE_TABLE "CREATE TABLE IF NOT EXISTS rides (vendor_id INTEGER, pickup_datetime, dropoff_datetime TEXT, passenger_count NUMERIC, trip_distance NUMERIC, pickup_longitude NUMERIC, pickup_latitude NUMERIC, rate_code INTEGER, dropoff_longitude NUMERIC, dropoff_latitude NUMERIC, payment_type INTEGER, fare_amount NUMERIC, extra NUMERIC, mta_tax NUMERIC, tip_amount NUMERIC, tolls_amount NUMERIC, improvement_surcharge NUMERIC, total_amount NUMERIC)"
/* you can use CREATE TABLE  IF NOT EXISTS TEST ... */
#define INPUTDATA "./nyc_data_rides.csv"
#define BUFFER_SIZE 256
/* $ wc -L nyc_data_rides.csv  => 168 */

int main(void) {
    sqlite3* db;
    sqlite3_stmt *stmt;
    int rc = 0;  /* return code */
    int ec = -1; /* exit code   */
    char *sErrMsg = 0;
    const char *tail = 0;
    FILE *pFile = 0;
    char sInputBuf[BUFFER_SIZE] = "\0";
    char sSQL[BUFFER_SIZE] = "\0";
    char *p = 0;
    long n = 0;
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
    if (rc != SQLITE_OK) {
        if (sErrMsg != NULL) {
            LOG_ERROR("Error: %s\n", sErrMsg);
            sqlite3_free(sErrMsg);
        } else {
            LOG_ERROR("Error: unknown.\n");
        }
        ec = 2;
        goto opendb_out;
    } else {
        LOG_DEBUG_CLOCK("sqlite3_exec()\n");
        LOG_INFO("Created table.\n");
        ec = 0;
    }

    sprintf(sSQL, "INSERT INTO rides VALUES (@a, @b, @c, @d, @e, @f, @g, @h, @i, @j, @k, @l, @m, @n, @o, @p, @q, @r)");
    sqlite3_prepare_v2(db, sSQL, BUFFER_SIZE, &stmt, &tail);

    sqlite3_exec(db, "BEGIN TRANSACTION", NULL, NULL, &sErrMsg);

    LOG_DEBUG("bulk insert start.\n");
    __LOG_CLOCK_START
    pFile = fopen(INPUTDATA, "r");
    while (!feof(pFile)) {
        p = fgets(sInputBuf, BUFFER_SIZE, pFile);
        if (p == NULL) { break; }
        // printf("%s\n", sInputBuf);
        sqlite3_bind_text(stmt, 1, strtok (sInputBuf, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 3, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 4, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 5, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 6, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 7, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 8, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 9, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 10, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 11, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 12, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 13, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 14, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 15, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 16, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 17, strtok (NULL, ","), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 18, strtok (NULL, ","), -1, SQLITE_TRANSIENT);

        sqlite3_step(stmt);
        sqlite3_clear_bindings(stmt);
        sqlite3_reset(stmt);

        n++;
    }
    fclose(pFile);
    __LOG_CLOCK_END
    LOG_DEBUG_CLOCK("bulk inser end.\n");
    printf("Count: %ld\n", n);
    sqlite3_exec(db, "END TRANSACTION", NULL, NULL, &sErrMsg);

opendb_out:
    if ( db ) {
        sqlite3_close(db);
        db = 0;
    }
    return ec;
}

