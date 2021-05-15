#!/usr/bin/env bash

cd `dirname $0`
cd ..
PWD=`pwd`

NAME=${PWD##*/}

disable_systemd() {
    local f=$1
    if [ -f /${f} ]; then
        echo "# systemctl daemon-reload ${f}"
        systemctl daemon-reload ${f}
        echo "# systemctl stop ${f}"
        systemctl stop ${f}
        echo "# systemctl disable ${f}"
        systemctl disable ${f}
    fi
}

DIR=etc/systemd/system

### disable and stop systemd timer
for f in ${DIR}/${NAME}.timer; do
    enable_systemd ${f}
done

