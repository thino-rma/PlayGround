import os
import sqlite3
from contextlib import closing
from logging import getLogger

class CommandInit:

  def __init__(self, space, interval, tcpos, pcpos = -1, pnum = 0):
    """
    constructor

    Parameters
    ----------
    space : str
        space name. this will be directory name.
        don't contain space and path separator.
    interval : str
        chunk time interval modifiers. '3D': 3 days, '1h': 1 hour, '10m": 10 minutes.
    tcpos : int [0-]
        timestamp column position (0 based)
    pcpos : int [0-]
        additional partition column position (0 based)
    pnum : int [1-]
        number of partitions.
        required if pcpos is specified.
        ignored if pcpos is not specified.

    >>> cmd = CommandInit("valid_name", "3D", 1)
    >>> cmd.space
    'valid_name'
    >>> cmd.interval
    '3D'
    >>> cmd.tcpos
    1
    >>> cmd = CommandInit("valid_name", "1h", 1)
    >>> cmd.interval
    '1h'
    >>> cmd = CommandInit("valid_name", "10m", 1)
    >>> cmd.interval
    '10m'
    >>> cmd = CommandInit("valid_name", "10m", 1, 2, 3)
    >>> cmd.pcpos
    2
    >>> cmd.pnum
    3
    >>> try:
    ...   cmd = CommandInit("invalid name", "1h", 1)
    ...   assert(False, "name contains space")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (contains ' ' or '/'?): space='invalid name'"
    >>> try:
    ...   cmd = CommandInit("invalid/name", "1h", 1)
    ...   assert(False, "name contains path separater")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (contains ' ' or '/'?): space='invalid/name'"
    >>> try:
    ...   cmd = CommandInit("valid_name", "", 1)
    ...   assert(False, "interval is empty")
    ... except ValueError as ex:
    ...      str(ex)
    "empty: interval=''"
    >>> try:
    ...   cmd = CommandInit("valid_name", "1x", 1)
    ...   assert(False, "interval x is invalid")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (Unit part): interval='1x'"
    >>> try:
    ...   cmd = CommandInit("valid_name", "0D", 1)
    ...   assert(False, "interval 0 is out of range")
    ... except ValueError as ex:
    ...      str(ex)
    "out of range [1-]: interval='0D'"
    >>> try:
    ...   cmd = CommandInit("valid_name", "1D", -1)
    ...   assert(False, "tcpos -1 is out of range")
    ... except ValueError as ex:
    ...      str(ex)
    'out of range [0-]: tcpos=-1'
    >>> try:
    ...   cmd = CommandInit("valid_name", "1D", 1, -1, 1)
    ...   assert(False, "pcpos -1 is out of range")
    ... except ValueError as ex:
    ...      str(ex)
    'out of range [0-]: pcpos=-1'
    >>> try:
    ...   cmd = CommandInit("valid_name", "1D", 1, 1)
    ...   assert(False, "pcpos is the same value as tcpos")
    ... except ValueError as ex:
    ...      str(ex)
    'pcpos is the same value as tcpos: pcpos=1'
    >>> try:
    ...   cmd = CommandInit("valid_name", "1D", 1, 2, 0)
    ...   assert(False, "")
    ... except ValueError as ex:
    ...      str(ex)
    'out of range [1-].: pnum=0'
    """
    if len(space) == 0:
      raise ValueError("{}: {}='{}'".format("empty",
                                            "space",
                                            space))
    if os.sep in space or " " in space:
      raise ValueError("{}: {}='{}'".format("invalid form (contains ' ' or '{}'?)".format(os.sep),
                                            "space",
                                            space))
    if len(interval) == 0:
      raise ValueError("{}: {}='{}'".format("empty",
                                            "interval",
                                            interval))
    try:
      _interval_number = int(interval[0:-1])
    except:
      raise ValueError("{}: {}='{}'".format("invalid form (Number part)",
                                            "interval",
                                            interval))
    if _interval_number < 1:
      raise ValueError("{}: {}='{}'".format("out of range [1-]",
                                            "interval",
                                            interval))

    _interval_unit = interval[-1]
    if _interval_unit not in ["M", "D", "h", "m", "s"]:
      raise ValueError("{}: {}='{}'".format("invalid form (Unit part)",
                                            "interval",
                                            interval))

    if tcpos < 0:
      raise ValueError("{}: {}={}".format("out of range [0-]",
                                            "tcpos",
                                            tcpos))

    if pcpos == -1 and pnum == 0:
      pass
    else:
      if pcpos < 0:
        raise ValueError("{}: {}={}".format("out of range [0-]",
                                            "pcpos",
                                            pcpos))

      if tcpos == pcpos:
        raise ValueError("{}: {}={}".format("pcpos is the same value as tcpos",
                                            "pcpos",
                                            pcpos))

      if pnum < 1:
        raise ValueError("{}: {}={}".format("out of range [1-].",
                                              "pnum",
                                              pnum))

    self.__space = space
    self.__interval = interval
    self.__tcpos = tcpos
    self.__pcpos = pcpos
    self.__pnum  = pnum


  @property
  def space(self):
    return self.__space

  @property
  def interval(self):
    return self.__interval

  @property
  def tcpos(self):
    return self.__tcpos

  @property
  def pcpos(self):
    return self.__pcpos

  @property
  def pnum(self):
    return self.__pnum

  def run(self):
    """
    run initialization

    create a directory with name specified with space argument.
    create a sqlite3 database with name '__pysort.sqlite'
    """

    logger = getLogger(__name__)
    logger.info("run() start.")
    configs = []
    configs.append(("interval", self.__interval))
    configs.append(("tcpos", self.__tcpos))
    configs.append(("pcpos", self.__pcpos))
    configs.append(("pnum", self.__pnum))

    from StoreEngine import StoreEngine
    StoreEngine.init_store(self.__space, configs)
    logger.info("run() complete.")

if __name__ == '__main__':
  import doctest
  doctest.testmod()
