#! /bin/bash
log=$HOME/logs/trj.log
php -S 0.0.0.0:$2 -t $1 2>$log &
echo "#### web start...end!!!!!!\r\n"
cd $HOME
ls $HOME
