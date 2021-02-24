#!/bin/bash

if [ -f /etc/lsb-release ]; then
    ACCESSLOG=/var/log/apache2/access.log
elif [ -f /etc/redhat-release ]; then
    ACCESSLOG=/var/log/httpd/ssl_access_log
fi

if [ -z $1 ]; then
    cat ${ACCESSLOG} \
        | sed -e 's/^\(\S\+\) \(\S\+\) \(\S\+\) \(\[.*\]\) \("[^"]\+"\) \([0-9]\+\) \(.*\)$/>>> \1\t\4\t\6\t\5 <<</'
    exit 0
fi
if [ "$1" == "-v" ]; then
    cat ${ACCESSLOG} \
        | sed -e 's/^\(\S\+\) \(\S\+\) \(\S\+\) \(\[.*\]\) \("[^"]\+"\) \([0-9]\+\) \(.*\)$/>>> \1\t\4\t\6\t\5 <<</' \
        | grep $1 $'\t'"$2"$'\t'
else
    cat ${ACCESSLOG} \
        | sed -e 's/^\(\S\+\) \(\S\+\) \(\S\+\) \(\[.*\]\) \("[^"]\+"\) \([0-9]\+\) \(.*\)$/>>> \1\t\4\t\6\t\5 <<</' \
        | grep $'\t'"$1"$'\t'
fi
