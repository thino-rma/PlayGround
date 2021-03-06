### How to build
```
wget https://raw.githubusercontent.com/thino-rma/PlayGround/master/golang/dumb/dumb.go
go build -o dumb dumb.go
mkdir ~/bin
mv dumb ~/bin
```

### Help
```
$ dumb -h
usage: dumb [-h] [-f LOGPATH] [-p PIDPATH]

dumb - tiny logging program.

  Signal SIGUSR1 cause to reopen the logfile.
  Permission of the newly created files is 640 ('rw-r----').

optional arguments:
  -h, --help  show this help message and exit
  -f LOGPATH  Log file path
  -p PIDPATH  PID file path

simple usage: standard output will be stored into test.log
  command | dumb -f test.log

log rotatation:
  command | dumb -f test.log -p test.pid
  mv test.log{,.`date +'%Y%m%d%H%M%S'`}
  kill -SIGUSR1 `cat test.pid`

setting setgid permission to the log directory:
  mkdir /var/log/test
  chown root:zabbix /var/log/test
  command | dumb -f /var/log/test/test.log -p /var/run/test.pid
  mv /var/log/test/test.log{,.`date +'%Y%m%d%H%M%S'`}
  kill -SIGUSR1 `cat /var/run/test.pid`

automated log rotation:
  use cron or logrotate.
```

### Log rotate
```
$ cat rotatelog.sh
#!/bin/bash

LOGFILE=/var/log/test.log
PIDFILE=/var/run/test.pid
if [ -f ${PIDFILE} ]; then
    PID=`cat ${PIDFILE}`
    ps aux | grep -v grep | grep "$PID" | grep "dumb -f ${LOGFILE} -p ${PIDFILE}" &> /dev/null
    if [ $? -eq 0 ]; then
        mv ${LOGFILE}{,.`date +'%Y%m%d%H%M%S'`}
        kill -SIGUSR1 ${PID}
    fi
fi
```
