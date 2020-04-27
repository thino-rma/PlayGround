/*
 * $ gcc -Wall -g -O2 -I/usr/include/postgresql -L/usr/lib/x86_64-linux-gnu -o pg-loader pg-loader.c -lpq
 * $ sudo -u postgres ./pg-loader
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <libpq-fe.h>
#include "logstdout.h"

#define DPGS_GETRESLT_TEXT   0
#define DPGS_GETRESLT_BINARY 1

#define INPUTDATA "./nyc_data_rides.csv"
#define FIELD_COUNT 18
#define BUFFER_SIZE 256
/* $ wc -L nyc_data_rides.csv  => 168 */

int main(void){
  PGconn   *conn      = NULL;
  PGresult *res       = NULL;
  FILE     *pFile     = 0;
  char      sInputBuf[BUFFER_SIZE];
  char      sql_str[BUFFER_SIZE];
  const char *paramValues[FIELD_COUNT];
  char     *user      = "postgres";
  char     *passwd    = "";
  char     *db_name   = "nyc_data";
  char     *p         = 0;
  long      n         = 0;
  int       i         = 0;
  __LOG_CLOCK_INIT
  memset( &sInputBuf[0] , 0x00 , sizeof(sInputBuf) );
  memset( &sql_str[0] , 0x00 , sizeof(sql_str) );

  LOG_INFO("PQsetdbLogin()\n");
  /* DB接続 */
  conn = PQsetdbLogin(
           NULL ,     // hostname NULL then use UNIX domain socket
           NULL ,     // port
           NULL ,     // debug option
           NULL ,     // file or tty for debug
           db_name ,  // database name
           user    ,  // user(role)
           passwd     // password
         );
  if( PQstatus(conn) == CONNECTION_BAD ){
    LOG_ERROR("Login failed: %s\n", PQerrorMessage(conn));
    PQfinish(conn);
    exit(1);
  }

  res = PQexec(conn, "SET synchronous_commit = 'off';");
  if (PQresultStatus(res) != PGRES_COMMAND_OK) {
    LOG_ERROR("SET command failed: %s\n", PQerrorMessage(conn));
    PQclear(res);
    PQfinish(conn);
    exit(1);
  }
  PQclear(res);

  /* begin transaction */
  res = PQexec(conn, "BEGIN");
  if (PQresultStatus(res) != PGRES_COMMAND_OK) {
    LOG_ERROR("BEGIN command failed: %s\n", PQerrorMessage(conn));
    PQclear(res);
    PQfinish(conn);
    exit(1);
  }
  PQclear(res);

  LOG_DEBUG("bulk insert start.\n");
  __LOG_CLOCK_START
  pFile = fopen(INPUTDATA, "r");
  if (pFile==NULL)
  {
    LOG_ERROR("pFile is NULL. file not found?: %s\n", INPUTDATA);
    PQfinish(conn);
    exit(1);
  }
  while (!feof(pFile)) {
    p = fgets(sInputBuf, BUFFER_SIZE, pFile);
    if (p == NULL) { break; }

    paramValues[0] = strtok (sInputBuf, ",");
    for (i = 1; i < FIELD_COUNT; i++) {
      paramValues[i] = strtok (NULL, ",");
    }

    res = PQexecParams(conn, "INSERT INTO rides  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18);",
            FIELD_COUNT, /* params */
            NULL,        /* let the backend deduce param type */
            paramValues,
            NULL,        /* don't need param lengths since text */
            NULL,        /* default to all text params */
            0);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
      LOG_ERROR("INSERT command failed: %s\n", PQerrorMessage(conn));
      PQclear(res);
      PQfinish(conn);
    }
    PQclear(res);

    n++;
  }

  /* commit transaction */
  res = PQexec(conn, "COMMIT");
  if (PQresultStatus(res) != PGRES_COMMAND_OK) {
    LOG_ERROR("COMMIT command failed: %s\n", PQerrorMessage(conn));
    PQclear(res);
    PQfinish(conn);
    exit(1);
  }
  PQclear(res);

  PQclear(res);
  __LOG_CLOCK_END
  LOG_DEBUG_CLOCK("bulk insert end.\n");

  LOG_INFO("COUNT %ld\n", n);
  PQfinish(conn);
  
  return 0;
}

