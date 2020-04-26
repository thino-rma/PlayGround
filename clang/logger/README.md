Description:
============
    This is a logging program, reads from stdin, writes to logfile.
    If interval > 0, rotate log when new input arrived.
    This program uses fgets().

Usage:
======
    ./mylogger -h|--help
    ./mylogger --dry-run -f FILE [-l length] [-i interval] [-d delay]
    command | ./mylogger [--dry-run] -f FILE [-l length] [-i interval] [-d delay]

Caution:
========
    If specified value is out of range, it will be rounded.
    Use '--dry-run' to check how the arguments were parsed.

Options:
========
    -h|--help    show usage and exit.
    --dry-run    show parsed arguments and exit.
    -f FILE      log file name
    -l length    line size in bytes (integer)
                 this must includes terminating null character.
                 default is 4096.
                   (min, max)=(64, 2147483647)
    -i interval  log rotate interval in seconds.
                 rotation occures when new input arrives.
                 default is 0.
                   (min, max)=(0, 2147483647)
                       0 : no rotation
                      60 : minutely.
                    3600 : hourly.
                   86400 : daily.
    -d delay     log rotate delay in seconds.
                 ignored when interval is 0.
                   (min, max)=(-2147483648, 2147483647)

