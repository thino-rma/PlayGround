#!/usr/bin/env bash

cd `dirname $0`
cd ..
PWD=`pwd`

NAME=${PWD##*/}
DATE=`date +"%Y%m%d-%H%M%S"`

backup_file() {
    local f=$1
    if [ -f /${f} ]; then
        echo "mv /${f} ./${f}.${DATE}"
        mv /${f} ./${f}.${DATE}
    fi
}

### undeploy systemd service/timer files
DIR=etc/systemd/system
for f in ${DIR}/${NAME}.service ${DIR}/${NAME}.timer; do
    backup_file ${f}
done

### undeploy crond config
DIR=etc/cron.d
for f in ${DIR}/${NAME}; do
    backup_file ${f}
done

### undeploy logrotated config
DIR=etc/logrotate.d
for f in ${DIR}/${NAME}; do
    backup_file ${f}
done

