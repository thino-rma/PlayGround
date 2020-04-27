/*
 * $ gcc -Wall -g -O2 -I/usr/include/postgresql -L/usr/lib/x86_64-linux-gnu -o pg-version pg-version.c -lpq
 * $ sudo -u postgres ./pg-version
 * 0 : PostgreSQL 12.2 (Ubuntu 12.2-2.pgdg18.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0, 64-bit
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <libpq-fe.h>

#define DPGS_GETRESLT_TEXT   0
#define DPGS_GETRESLT_BINARY 1

int main(void){
  PGconn   *conn      = NULL;
  PGresult *res       = NULL;
  char      sql_str[255];
  char     *user      = "postgres";
  char     *passwd    = "";
  char     *db_name   = "postgres";
  int      res_cnt    = 0;
  int      loop       = 0;
  memset( &sql_str[0] , 0x00 , sizeof(sql_str) );

  /* DB接続 */
  conn = PQsetdbLogin(
           NULL ,     // 接続先  NULLでUNIXドメインソケットの利用
           NULL ,     // ポート番号
           NULL ,     // デバッグオプション
           NULL ,     //デバッグ出力のためのファイル,またはtty名
           db_name ,  // DB名
           user    ,  // ユーザ名
           passwd     // パスワード
         );
  // エラーチェック
  if( PQstatus(conn) == CONNECTION_BAD ){
    fprintf(stderr, "Login failed: %s\n", PQerrorMessage(conn));
    PQfinish(conn);
    exit(1);
  }
  // パラメータセット
  res = PQexec(conn, "SET synchronous_commit = 'off';");
  if (PQresultStatus(res) != PGRES_COMMAND_OK) {
    fprintf(stderr, "SET command failed: %s\n", PQerrorMessage(conn));
    PQclear(res);
    PQfinish(conn);
    exit(1);
  }
  PQclear(res);

  // select文の発行
  snprintf( &sql_str[0] , sizeof(sql_str)-1 , "SELECT version();" );
  res = PQexecParams(
           conn                 , // 接続オブジェクト
           &sql_str[0]          , // 発行SQL文
           0                    , // パラメータ数
           NULL                 , // パラメータのデータ型
           NULL                 , // パラメータ値
           NULL                 , // パラメータのデータ長
           NULL                 , // パラメータのフォーマット形式
           DPGS_GETRESLT_BINARY   // 結果をバイナリで取得
         );
  res = PQexec( conn , &sql_str[0] );
  if( PQresultStatus( res ) != PGRES_TUPLES_OK ) {
    fprintf(stderr, "SELECT command failed: %s\n", PQerrorMessage(conn));
    PQclear(res);
    PQfinish(conn);
    exit(1);
  }

  res_cnt = PQntuples(res); // レスポンスの取得
  for(loop=0; loop < res_cnt ;loop++) {
    printf("%d : %s\n",
           loop,
           PQgetvalue(res, loop , 0)
          );
  }
  PQclear(res);

  PQfinish(conn);
  
  return 0;
}

