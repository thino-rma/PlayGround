#!/usr/bin/env bash

cd `dirname $0`
cd ..
PWD=`pwd`

NAME=${PWD##*/}

copy_file() {
    local f=$1
    if [ -f ${f} ] && [ ! -f /${f} ]; then
        echo "cp -a ./${f} /${f}"
        cp -a ./${f} /${f}
    fi
}

### set executable
[ -f bin/execute.sh ] && chmod u+x bin/execute.sh

### deploy systemd service/timer files
DIR=etc/systemd/system
for f in ${DIR}/${NAME}.service ${DIR}/${NAME}.timer; do
    copy_file ${f}
done

### deploy crond config
DIR=etc/cron.d
for f in ${DIR}/${NAME}; do
    copy_file ${f}
done

### deploy logrotated config
DIR=etc/logrotate.d
for f in ${DIR}/${NAME}; do
    copy_file ${f}
done

