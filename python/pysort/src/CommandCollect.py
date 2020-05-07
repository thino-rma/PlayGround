import os
import sqlite3
from contextlib import closing
from logging import getLogger
from StoreEngine import StoreEngine

class CommandCollect:

  def __init__(self, space, filepath, count=0):
    """
    constructor

    Parameters
    ----------
    space : str
        space name. this will be directory name.
        don't contain space and path separator.
    filepath : str
        file path to write.
    count : int [0-]
        line count to write.

    >>> cmd = CommandCollect("valid_name", "../tmp/collect.csv")
    >>> cmd.space
    'valid_name'
    >>> cmd.filepath
    '../tmp/collect.csv'
    >>> cmd.count
    0
    >>> try:
    ...   cmd = CommandCollect("invalid name", "../tmp/collect.csv")
    ...   assert(False, "name contains space")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (contains ' ' or '/'?): space='invalid name'"
    >>> try:
    ...   cmd = CommandCollect("invalid/name", "../tmp/collect.csv")
    ...   assert(False, "name contains path separater")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (contains ' ' or '/'?): space='invalid/name'"
    >>> try:
    ...   cmd = CommandCollect("valid_name", "")
    ...   assert(False, "filepath is empty")
    ... except ValueError as ex:
    ...      str(ex)
    "empty: filepath=''"
    >>> try:
    ...   cmd = CommandCollect("valid_name", "../tmp/test.csv")
    ...   assert(False, "file exists")
    ... except ValueError as ex:
    ...      str(ex)
    "file exists: filepath='../tmp/test.csv'"
    """
    if len(space) == 0:
      raise ValueError("{}: {}='{}'".format("empty",
                                            "space",
                                            space))
    if os.sep in space or " " in space:
      raise ValueError("{}: {}='{}'".format("invalid form (contains ' ' or '{}'?)".format(os.sep),
                                            "space",
                                            space))

    # if not os.path.isdir(space):
    #   raise ValueError("{}: {}='{}'".format("space not found",
    #                                         "space",
    #                                         space))

    if filepath is not None:
      if len(filepath) == 0:
        raise ValueError("{}: {}='{}'".format("empty",
                                              "filepath",
                                              filepath))
      if os.path.exists(filepath):
        raise ValueError("{}: {}='{}'".format("file exists",
                                              "filepath",
                                              filepath))

    if count < 0:
      raise ValueError("{}: {}={}".format("out of range [0-]",
                                              "count",
                                              count))

    self.__space = space
    self.__filepath = filepath
    self.__count = count


  @property
  def space(self):
    return self.__space


  @property
  def filepath(self):
    return self.__filepath


  @property
  def count(self):
    return self.__count


  def run(self):
    """
    run collect data

    read from space, write to filepath
    """

    logger = getLogger(__name__)
    logger.info("run() start.")

    with closing(StoreEngine(self.__space)) as engine:
      engine.collect(self.__filepath, self.__count)

    logger.info("run() complete.")


if __name__ == '__main__':
  import doctest
  doctest.testmod()
