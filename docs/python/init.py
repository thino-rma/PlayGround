import psycopg2

# %load ./init.py
# or %run -i './init.py'

host = '192.168.0.x'
host = 'localhost'
user = 'user'
dbname = 'user'
connstr = "host={} user={} dbname={}".format(host,user,dbname)
conn = psycopg2.connect(connstr)

def print_schema(tblname):
      sql = """\
      select schemaname, tablename, tableowner from pg_tables
      where tableowner = 'hino'
      and tablename = %s
      order by schemaname, tablename;
      """
      # excexute sql
      conn = psycopg2.connect(connstr)
      cur = conn.cursor()
      cur.execute(sql, (tblname,))
      results = cur.fetchall()
      for t in results:
          print(t)
      conn.close()

def print_result(sql, params=()):
      # excexute sql
      conn = psycopg2.connect(connstr)
      cur = conn.cursor()
      cur.execute(sql, params)
      results = cur.fetchall()
      colnames = [desc[0] for desc in cur.description]
      print(colnames)
      for t in results:
          print(t)
      conn.close()

import pandas as pd
def get_df(sql, params=()):
      conn = psycopg2.connect(connstr)
      if len(params) == 0:
          df = pd.read_sql(sql, con=conn)
      else:
          df = pd.read_sql(sql, con=conn, params=params)
      conn.close()
      return df

def show_summary(df):
      print(df.info())
      for i, col in enumerate(df.columns):
        s = df[col].value_counts()
        print()
        print("="*33)
        print("# {:3d} {:20s} {:6d}".format(i, col, s.count()))
        print("  {} {} {}".format("-"*3, "-"*20, "-"*6))
        print(s.head())

print("def print_schema(tblname)")
print("def print_result(sql, params=())")
print("def get_df(sql, params=())")
print("def show_summary(df)")

if __name__ == '__main__':
    print_schema('hoge')
