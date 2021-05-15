#!/usr/bin/env bash

cd `dirname $0`
cd ..
PWD=`pwd`

exec 1> ./log/`basename $0`.stdout.log
exec 2> ./log/`basename $0`.stderr.log

decho() {
    echo `date +"%Y%m%d-%H%M%S"` $@
}

decho "$0 started."  ######################################

decho "$0 finished." ######################################



