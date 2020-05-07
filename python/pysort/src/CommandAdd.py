import os
import sqlite3
from contextlib import closing
from logging import getLogger
from StoreEngine import StoreEngine

class CommandAdd:

  def __init__(self, space, filepath, skiprows = 0, delimiter = ""):
    """
    constructor

    Parameters
    ----------
    space : str
        space name. this will be directory name.
        don't contain space and path separator.
    filepath : str
        file path to read.
    column : int [0-]
        timestamp column position
    skiprows : int [0-]
        skip rows.
    delimiter : str
        delimiter character. if not specified, guess from file extention, ',' for '.csv', '\\t' for '.tsv'.

    >>> cmd = CommandAdd("valid_name", "../tmp/test.csv", 1)
    >>> cmd.space
    'valid_name'
    >>> cmd.filepath
    '../tmp/test.csv'
    >>> cmd.skiprows
    1
    >>> cmd.delimiter
    ','
    >>> cmd = CommandAdd("valid_name", "../tmp/test.tsv", 2)
    >>> cmd.space
    'valid_name'
    >>> cmd.filepath
    '../tmp/test.tsv'
    >>> cmd.skiprows
    2
    >>> cmd.delimiter
    '\\t'
    >>> cmd = CommandAdd("valid_name", "../tmp/test.csv",  1, "")
    >>> cmd.filepath
    '../tmp/test.csv'
    >>> cmd.skiprows
    1
    >>> cmd.delimiter
    ','
    >>> cmd = CommandAdd("valid_name", "../tmp/test.tsv",  2, "")
    >>> cmd.filepath
    '../tmp/test.tsv'
    >>> cmd.skiprows
    2
    >>> cmd.delimiter
    '\\t'
    >>> cmd = CommandAdd("valid_name", "../tmp/test.csv",  3, "|")
    >>> cmd.filepath
    '../tmp/test.csv'
    >>> cmd.skiprows
    3
    >>> cmd.delimiter
    '|'
    >>> try:
    ...   cmd = CommandAdd("invalid name", "../tmp/test.cvs", 2)
    ...   assert(False, "name contains space")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (contains ' ' or '/'?): space='invalid name'"
    >>> try:
    ...   cmd = CommandAdd("invalid/name", "../tmp/test.csv", 2)
    ...   assert(False, "name contains path separater")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (contains ' ' or '/'?): space='invalid/name'"
    >>> try:
    ...   cmd = CommandAdd("valid_name", "", "2")
    ...   assert(False, "filepath is empty")
    ... except ValueError as ex:
    ...      str(ex)
    "empty: filepath=''"
    >>> try:
    ...   cmd = CommandAdd("valid_name", "../tmp/test.xyz", 2)
    ...   assert(False, "file not found")
    ... except ValueError as ex:
    ...      str(ex)
    "file not found: filepath='../tmp/test.xyz'"
    >>> try:
    ...   cmd = CommandAdd("valid_name", "../tmp/test.csv", -1, "")
    ...   assert(False, "skiprows -1 is out of range")
    ... except ValueError as ex:
    ...      str(ex)
    'out of range [0-]: skiprows=-1'
    """
    if len(space) == 0:
      raise ValueError("{}: {}='{}'".format("empty",
                                            "space",
                                            space))
    if os.sep in space or " " in space:
      raise ValueError("{}: {}='{}'".format("invalid form (contains ' ' or '{}'?)".format(os.sep),
                                            "space",
                                            space))
    if len(filepath) == 0:
      raise ValueError("{}: {}='{}'".format("empty",
                                            "filepath",
                                            filepath))
    if not os.path.exists(filepath):
      raise ValueError("{}: {}='{}'".format("file not found",
                                            "filepath",
                                            filepath))

    if skiprows < 0:
      raise ValueError("{}: {}={}".format("out of range [0-]",
                                              "skiprows",
                                              skiprows))

    if len(delimiter) == 0:
      _, ext = os.path.splitext(filepath)
      if ext == ".csv":
        delimiter = ','
      elif ext == ".tsv":
        delimiter = '\t'
      else:
        raise ValueError("{}: {}={}".format("empty",
                                            "delimiter",
                                            delimiter))

    self.__space = space
    self.__filepath = filepath
    self.__skiprows = skiprows
    self.__delimiter = delimiter


  @property
  def space(self):
    return self.__space

  @property
  def filepath(self):
    return self.__filepath

  @property
  def column(self):
    return self.__column

  @property
  def skiprows(self):
    return self.__skiprows

  @property
  def delimiter(self):
    return self.__delimiter


  def run(self):
    """
    run add data

    read from file
    for each row
      open/create a directory according to timestamp value (and additional partition column value).
      open/create a sqlite3 database
      insert a record
    """

    logger = getLogger(__name__)
    logger.info("run() start.")
    from datetime import datetime
    with closing(StoreEngine(self.__space)) as engine:
      engine.add(self.__filepath, self.__skiprows, self.__delimiter)
    logger.info("run() complete.")


  def dry_run(self):
    """
    dry run
    """

    logger = getLogger(__name__)
    logger.info("dry_run() start.")

    count = 0
    with closing(StoreEngine(self.__space)) as engine:
      with open(self.__filepath) as f:
        for _ in range(self.__skiprows):
          _ = f.readline()

        for line in f:
          line = line.rstrip()
          logger.info(str(engine.analyze(line, self.__delimiter)))

          count += 1
          if count > 10:
            break

    logger.info("dry_run() complete.")

if __name__ == '__main__':
  import doctest
  doctest.testmod()
