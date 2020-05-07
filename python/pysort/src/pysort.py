import sys
import argparse
import textwrap
from logging import getLogger, INFO, DEBUG

def command_init(args):
  from CommandInit import CommandInit
  cmd = CommandInit(args.space, args.interval, args.tcpos, args.pcpos, args.pnum)
  cmd.run()


def command_config(args):
  from CommandConfig import CommandConfig
  cmd = CommandConfig(args.space)
  if args.set is None:
    cmd.get(args.key)
  else:
    cmd.set(args.key, args.set)


def command_add(args):
  print(args)
  from CommandAdd import CommandAdd
  cmd = CommandAdd(args.space, args.file, args.skiprows, args.delimiter)
  if args.dryrun:
    cmd.dry_run()
  else:
    cmd.run()


def command_collect(args):
  print(args)
  from CommandCollect import CommandCollect
  cmd = CommandCollect(args.space, args.file)
  if args.file == "-":
    cmd = CommandCollect(args.space, None, args.count)
  else:
    cmd = CommandCollect(args.space, args.file)

  cmd.run()

def command_remove(args):
  print(args)


def __init_argparser():
  # build argument parser
  parser = argparse.ArgumentParser(description="pysort: sort program for time seriese big data.")
  subparsers = parser.add_subparsers()

  parser_init = subparsers.add_parser('init', help="initialize space. See `init -h`")
  parser_init.add_argument("space",
                           help="space name for time seriese big data.")
  parser_init.add_argument("interval",
                           help="chunk time interval. '7d' for 7 days, '1h' for 1 hour, '10m' for 10 minutes")
  parser_init.add_argument("tcpos", type=int,
                          help="timestamp column position [0-] (0 based).")
  group_partitioning = parser_init.add_argument_group("additional partitioning")
  group_partitioning.add_argument("--pcpos", default=-1,
                           help="additional partition column position [0-] (0 based). if provided, the '--num' argument must also be provided.")
  group_partitioning.add_argument("--pnum", default="0", type=int,
                           help="number [1-] for additional partitions.")
  parser_init.set_defaults(handler=command_init)

  parser_config = subparsers.add_parser('config', help="show config. See `config -h`")
  parser_config.add_argument("space",
                             help="space name.")
  parser_config.add_argument("key",
                             help="key")
  parser_config.add_argument("--set", metavar="VALUE",
                             help="set VALUE to the key.")
  parser_config.set_defaults(handler=command_config)

  parser_add = subparsers.add_parser('add', help="add data. See `add -h`")
  parser_add.add_argument("space",
                          help="space name.")
  parser_add.add_argument("file",
                          help="file path to read.")
  parser_add.add_argument("-s", "--skiprows", metavar="N", default=0, type=int,
                          help="skip rows to remove header.")
  parser_add.add_argument("-d", "--delimiter", metavar="CHAR", default='',
                          help="separator character. if ommited, ',' when extention of file is '.csv', '\t' when '.tsv'.")
  parser_add.add_argument("--dryrun", action='store_true',
                          help="dry run." )
  parser_add.set_defaults(handler=command_add)

  parser_collect = subparsers.add_parser('collect', help="collect data. See `collect -h`")
  parser_collect.add_argument("space",
                              help="space name.")
  parser_collect.add_argument("file",
                              help="file path to write. if '-' specified, write to stdout.")
  parser_collect.add_argument("--count", metavar="N", default=0, type=int,
                              help="line count to write. ignored if file is no '-'.")
  parser_collect.set_defaults(handler=command_collect)

  parser_remove = subparsers.add_parser('remove', help="remove data. See `add -h`")
  parser_remove.add_argument("space",
                             help="space name.")
  parser_remove.add_argument("range",
                             help="range to delete. e.g. [2020-01-01::2020-02-01)")
  parser_remove.set_defaults(handler=command_remove)

  return parser

def __setup_logger(loglevel=DEBUG, logfile="pysort.log"):

    logger = getLogger()
    logger.setLevel(DEBUG)

    import logging.handlers
    fh = logging.handlers.TimedRotatingFileHandler(
            filename=logfile,
            when='midnight')
    fh.setLevel(loglevel)
    fmt = "%(asctime)s [%(levelname)s] %(name)s %(filename)s#%(lineno)d :%(message)s"
    fh_formatter = logging.Formatter(fmt)
    fh.setFormatter(fh_formatter)
    logger.addHandler(fh)

    ch = logging.StreamHandler()
    ch.setLevel(loglevel)
    ch_formatter = logging.Formatter('%(asctime)s [%(levelname)s] %(message)s')
    ch.setFormatter(ch_formatter)
    logger.addHandler(ch)


if __name__ == '__main__':
  # execute doctest
  if "---doctest" in sys.argv[1:]:
    import doctest
    doctest.testmod()

  parser = __init_argparser()
  __setup_logger()

  args = parser.parse_args()
  if hasattr(args, 'handler'):
    args.handler(args)
  else:
    parser.print_help()

