#!/usr/bin/bash env

cd `dirname $0`

if [ -z "$1" ]; then
    echo "Usage: $0 PROJ"
    echo "    PROJ  -  project name"
    exit 11
fi

PROJ=$1

if [ -d "${PROJ}" ]; then
    echo "directory found.: ${PROJ}"
fi
echo $PROJ

echo "creating directory.: ${PROJ}"
mkdir -p "${PROJ}/bin" "${PROJ}/etc" "${PROJ}/log" "${PROJ}/sbin"

URL=https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/admin/base
 
curl -L -o ${PROJ}/bin/execute.sh        ${URL}/bin/execute.sh
curl -L -o ${PROJ}/etc/systemd/system/${PROJ}.service ${URL}/etc/systemd/system/base.service
curl -L -o ${PROJ}/etc/systemd/system/${PROJ}.timer   ${URL}/etc/systemd/system/base.timer
sed -i "s/ = base/ = ${PROJ} " ${PROJ}/etc/systemd/system/${PROJ}.service
sed -i "s/ = base/ = ${PROJ} " ${PROJ}/etc/systemd/system/${PROJ}.timer
curl -L -o ${PROJ}/sbin/deploy.sh        ${URL}/sbin/deploy.sh
curl -L -o ${PROJ}/sbin/undeploy.sh      ${URL}/sbin/undeploy.sh
curl -L -o ${PROJ}/sbin/status.sh        ${URL}/sbin/status.sh
curl -L -o ${PROJ}/sbin/enable_timer.sh  ${URL}/sbin/enable_timer.sh
curl -L -o ${PROJ}/sbin/disable_timer.sh ${URL}/sbin/disable_timer.sh

