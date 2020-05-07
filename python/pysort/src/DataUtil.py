

class DataUtil:
  @staticmethod
  def split_timestamp(value):
    """
    split timestamp

      '0123456789012345678'
      'YYYY-MM-DD hh:mm:ss'
      -> 'YYYY', 'MM', 'DD', 'hh', 'mm', 'ss'

    >>> l = DataUtil.split_timestamp('YYYY-MM-DD hh:mm:ss')
    >>> l[0]
    'YYYY'
    >>> l[1]
    'MM'
    >>> l[2]
    'DD'
    >>> l[3]
    'hh'
    >>> l[4]
    'mm'
    >>> l[5]
    'ss'
    """
    return value[0:4], \
           value[5:7], \
           value[8:10], \
           value[11:13], \
           value[14:16], \
           value[17:19]


if __name__ == '__main__':
  import doctest
  doctest.testmod()

