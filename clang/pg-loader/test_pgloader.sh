date
max=1
for ((i=0; i < $max; i++)); do
    echo "COUNT $i" | ~/bin/mylogger -f test.log
    sudo -u postgres ./pg-loader | ~/bin/mylogger -f test.log
done
date

