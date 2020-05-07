import os
import sys
import sqlite3
from contextlib import closing
from logging import getLogger
from collections import OrderedDict

class StoreEngine:

  SQL_INSERT = "INSERT INTO pt (tc, line) VALUES (?, ?);"
  SQL_SELECT = "SELECT line FROM pt ORDER BY tc;"

  def __init__(self, space):
    if not os.path.isdir(space):
      raise ValueError("not initialized: space={}".format(space))

    self.__space = space
    self.__space_path = StoreEngine.__build_space_path(space)
    self.__space_conn = None
    self.open()

    with closing(self.__space_conn.cursor()) as _cur:
      sql = "SELECT value FROM config WHERE key = ?"
      _cur.execute(sql, ["interval"])
      self.__interval = _cur.fetchone()[0]
      self.__interval_Num   = int(self.__interval[:-1])
      self.__interval_Unit  = self.__interval[-1]
      #
      # 'YYYY-MM-DD hh:mm:ss'
      #  0    1  2  3  4  5  : __interval_Pos
      #  01234567890123456789 : __interval_Pos2
      self.__interval_Pos   = { "D": 2, "h": 3, "m":4, "s":5 }[self.__interval_Unit]
      self.__interval_Pos2  = { "D": 10, "h": 13, "m":16, "s":19 }[self.__interval_Unit]
      _cur.execute(sql, ["tcpos"])
      self.__tcpos = int(_cur.fetchone()[0])
      _cur.execute(sql, ["pcpos"])
      self.__pcpos = int(_cur.fetchone()[0])
      _cur.execute(sql, ["pnum"])
      self.__pnum  = int(_cur.fetchone()[0])

    self.__partition_tuple_dict = OrderedDict()
    self.__partition_tuple_count = 0


  @property
  def space(self):
    return self.__space


  @staticmethod
  def __build_space_path(space):
    return os.sep.join([space, "__pysort.sqlite"])


  @staticmethod
  def init_store(space, configs):
    logger = getLogger(__name__)

    if os.path.isdir(space):
      logger.error("Directory found: {}".format(space))
      exit(2)

    try:
      logger.info("creating directory... : SPACE='{}'".format(space))
      os.makedirs(space)
    except Exception as ex:
      logger.error("Exception: {}".format(str(ex)))
      exit(2)

    _path = StoreEngine.__build_space_path(space)
    if os.path.exists(_path):
      logger.error("database found. :{}".format(_path))
      return 1

    logger.info("creating database... : PATH='{}'".format(_path))
    with closing(sqlite3.connect(_path)) as conn:
      with closing(conn.cursor()) as cur:
        logger.info("creating table... : TABLE='{}'".format("config"))
        sql = '''\
              CREATE TABLE config (key TEXT PRIMARY KEY,
                                   value TEXT);
              '''
        cur.execute(sql)

        sql = 'BEGIN;'
        cur.execute(sql)

        logger.info("adding records... : TABLE='{}'".format("config"))
        sql = '''\
              INSERT INTO config (key, value) VALUES (?, ?);
              '''
        cur.executemany(sql, configs)
        sql = 'COMMIT;'
        cur.execute(sql)
        logger.info("inserted config table. :{}".format(_path))


  def open(self):
    """
    open space database
    """

    if self.__space_conn is not None:
      return True

    try:
      self.__space_conn = sqlite3.connect(self.__space_path)
      return True
    except:
      return False


  def close(self):
    """
    close space database
    """

    if self.__space_conn is not None:
      self.__space_conn.close()
      for _conn, _cur in self.__partition_tuple_dict.values():
        _cur.execute("COMMIT;")
        _cur.close()
        _conn.close()

    return True


  def _build_partition_path_tuple(self, timestamp, __path_dict={}):
    """
    build partition path

    Parameter
    =========
    timestamp: str
        timestamp value 'YYYY-MM-DD hh:mm:ss'
    __path_dict: dict
        key  : if 'D' then 'YYYYMMDD', if 'h' then 'YYYYMMDDhh', if 'm' then 'YYYYMMDDhhmm', if 's' then 'YYYYMMDDhhmmss'
        value: tuple (dir, file)
    """
    from DataUtil import DataUtil

    _timestamp_tuple = DataUtil.split_timestamp(timestamp)
    # _key = "".join(_timestamp_tuple[:self.__interval_Pos + 1])
    _key = _timestamp_tuple[:self.__interval_Pos2]

    if _key not in __path_dict:

      _dir = os.sep.join(_timestamp_tuple[:self.__interval_Pos]) + os.sep

      _tmp = int(_timestamp_tuple[self.__interval_Pos])
      _tmp = (_tmp  // self.__interval_Num) * self.__interval_Num
      if self.__interval_Pos == 2: # means 'D' (1 base)
        _tmp += 1

      _file = "".join(_timestamp_tuple[:self.__interval_Pos])
      _file = "{}{:02}{}".format(_file, _tmp, ".sqlite")
      __path_dict[_key] = (os.sep.join([self.__space, _dir]), _file)

    return __path_dict[_key]


  def _get_partition_tuple(self, timestamp):
    logger = getLogger(__name__)

    _path_tuple = self._build_partition_path_tuple(timestamp)
    _path = "".join(_path_tuple)

    # logger.debug("_get_partition_tuple() : {}".format(_path))
    if _path not in self.__partition_tuple_dict:
      if (self.__partition_tuple_count > 100):
        # too many connection. close one.
        _key, _tuple = self.__partition_tuple_dict.popitem(False)
        self.__partition_tuple_count -= 1
        _conn, _cur = _tuple
        _cur.execute("COMMIT;")
        _cur.close()
        # logger.debug("_get_partition_tuple() close.   : {}".format(_key))
        _conn.close()

      if not os.path.isdir(_path_tuple[0]):
        os.makedirs(_path_tuple[0])

      _exist = os.path.isfile(_path)  # if not exists, 
                                      # execute CREATE TABLE/INDEX
                                      # just after connect().
      # logger.debug("_get_partition_tuple() connect. : {}".format(_path))
      _conn = sqlite3.connect(_path)

      _cur = _conn.cursor()
      if not _exist:
        # table name: pt (partition)
        # field name: tc (timestamp column)
        #             line (line) without linefeed
        _cur.execute("CREATE TABLE pt (tc TEXT, line TEXT);")
        _cur.execute("CREATE INDEX idx_pt_tc ON pt (tc);")
      _cur.execute("BEGIN;")

      self.__partition_tuple_dict[_path] = (_conn, _cur)
      self.__partition_tuple_count += 1

    return self.__partition_tuple_dict[_path]


  def get_configs(self):
    with closing(self.__space_conn.cursor()) as cur:
      sql = '''\
            SELECT key, value FROM config;
            '''
      cur.execute(sql)
      return cur.fetchall()


  def get_config(self, key):
    with closing(self.__space_conn.cursor()) as cur:
      sql = '''\
            SELECT key, value FROM config WHERE key = ?;
            '''
      cur.execute(sql, [key])
      return cur.fetchone()


  def set_config(self, key, value):
    with closing(self.__space_conn.cursor()) as cur:
      sql = '''\
            UPDATE config SET value = ? WHERE key = ?;
            '''
      cur.execute(sql, [value, key])
      _affected = cur.rowcount
      if _affected == 1:
        self.__space_conn.commit()
      return _affected


  def add(self, filepath, skiprows, sep):
    """
    add
        store all lines

    Parameter
    =========

    filepath : str
        file path
    skiprows : int
        skip rows
    sep : str
        separater (delimiter) CHAR
    """

    logger = getLogger(__name__)

    _cnt = 0

    with open(filepath) as f:
      for _ in range(skiprows):
        _ = f.readline()

      for _line in f:
        if _cnt % 100000 == 0:
          logger.info("count {}".format(_cnt))

        _line = _line.rstrip()

        _timestamp = _line.split(sep)[self.__tcpos]
        _, _cur = self._get_partition_tuple(_timestamp)

        _cur.execute(self.SQL_INSERT, [_timestamp, _line])

        _cnt += 1

        # if _cnt >= 10000:
        #   break

    logger.info("stored {}".format(_cnt))


  def analyze(self, line, sep):
    """
    analize

    Parameter
    =========
    fields
        fields for one line in the data file.
    """

    _fields = line.split(sep)
    _timestamp = _fields[self.__tcpos]
    return (_timestamp, self._build_partition_path_tuple(_timestamp))

  def collect(self, filepath, count=0):
    """
    collect

    Parameter
    =========
    filepath
        file path to write.
        if None, then write to stdout.
    count
        line count to write.
        if 0 then all data.
        if 10, then 10 lines only.
    """
    logger = getLogger(__name__)

    import glob
    _list = [self.__space]
    _list.extend([ '*' for _ in range(self.__interval_Pos)])
    _list.append("*.sqlite")
    _files = sorted(glob.glob("/".join(_list)))

    try:
      if filepath is None:
        # trace all subdirectories
        _count = 0
        _step = 0 if count == 0 else 1

        for _path in _files:
          # open sqlite3 database and select with ORDER BY
          logger.info("connecting... : '{}'".format(_path))
          with closing(sqlite3.connect(_path)) as _conn:
            with closing(_conn.cursor()) as _cur:
              for _row in _cur.execute(self.SQL_SELECT):
                # write result into stdout.
                sys.stdout.write(_row[0])
                sys.stdout.write('\n')
                _count += _step
                if _count >= count:
                  break

          logger.info("collected : '{}' ({} rows)".format(_path, _count))
          if _count >= count:
            break
      else:
        with open(filepath, "w") as _f:
          # trace all subdirectories
          for _path in _files:
            # open sqlite3 database and select with ORDER BY
            # logger.info("connecting... : '{}'".format(_path))
            with closing(sqlite3.connect(_path)) as _conn:
              with closing(_conn.cursor()) as _cur:
                for _row in _cur.execute(self.SQL_SELECT):
                  # write result into
                  _f.write(_row[0])
                  _f.write('\n')

            logger.info("collected : '{}'".format(_path))
    except IOError as ex:
      logger.error("IOError ({}): {}".format(type(ex), str(ex)))
    except Exception as ex:
      logger.error("Exception ({}): {}".format(type(ex), str(ex)))

