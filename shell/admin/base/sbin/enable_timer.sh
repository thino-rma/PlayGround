#!/usr/bin/env bash

cd `dirname $0`
cd ..
PWD=`pwd`

NAME=${PWD##*/}

enable_systemd() {
    local f=$1
    if [ -f /${f} ]; then
        echo "# systemctl daemon-reload ${f}"
        systemctl daemon-reload ${f}
        echo "# systemctl enable ${f}"
        systemctl enable ${f}
        echo "# systemctl start ${f}"
        systemctl start ${f}
    fi
}

DIR=etc/systemd/system

### enable and start systemd timer
for f in ${DIR}/${NAME}.timer; do
    enable_systemd ${f}
done

