import os
import sqlite3
from contextlib import closing

class CommandConfig:

  def __init__(self, space):
    """
    constructor

    Parameters
    ----------
    space : str
        space name. this will be directory name.
        don't contain space and path separator.

    >>> cmd = CommandInit("valid_name", "3D")
    >>> cmd.space
    'valid_name'
    >>> try:
    ...   cmd = CommandInit("invalid name", "1h")
    ...   assert(False, "name contains space")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (contains ' ' or '/'?): space='invalid name'"
    >>> try:
    ...   cmd = CommandInit("invalid/name", "1h")
    ...   assert(False, "name contains path separater")
    ... except ValueError as ex:
    ...      str(ex)
    "invalid form (contains ' ' or '/'?): space='invalid/name'"
    """
    if len(space) == 0:
      raise ValueError("{}: {}='{}'".format("empty",
                                            "space",
                                            space))
    if os.sep in space or " " in space:
      raise ValueError("{}: {}='{}'".format("invalid form (contains ' ' or '{}'?)".format(os.sep),
                                            "space",
                                            space))
    self.__space = space


  @property
  def space(self):
    return self.__space

  def get(self, key):
    """
    get

    get and show value for the key.
    """
    from StoreEngine import StoreEngine
    _engine = StoreEngine(self.__space)

    if key == "ALL":
      for k, v in _engine.get_configs():
        print("{} : {}".format(k, v))
    else:
      k, v = _engine.get_config(key)
      print("{} : {}".format(k, v))

  def set(self, key, value):
    """
    set

    set value for the key and show the result
    """
    from StoreEngine import StoreEngine
    _engine = StoreEngine(self.__space)

    _engine.set_config(key, value)
    self.get(key)

if __name__ == '__main__':
  import doctest
  doctest.testmod()
