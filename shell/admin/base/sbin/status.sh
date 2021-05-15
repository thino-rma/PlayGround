#!/usr/bin/env bash

cd `dirname $0`
cd ..
PWD=`pwd`

NAME=${PWD##*/}

show_status() {
    local f=$1
    if [ -f /${f} ]; then
        echo "file found. : /${f}"
        echo "# diff -up ${f} /${f}"
        diff -up ${f} /${f}
    fi
}

### deploy systemd service/timer files
DIR=etc/systemd/system
for f in ${DIR}/${NAME}.service ${DIR}/${NAME}.timer; do
    show_status ${f}
done

### deploy crond config
DIR=etc/cron.d
for f in ${DIR}/${NAME}; do
    show_status ${f}
done

### deploy logrotated config
DIR=etc/logrotate.d
for f in ${DIR}/${NAME}; do
    show_status ${f}
done

