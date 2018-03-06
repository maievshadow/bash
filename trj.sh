#! /bin/bash
address=90
port=62315
nums=2
echo ">"
if [ $# -lt 2 ]
then
	echo "needed two arguments: address port" 
	echo "USAGE" \
	echo "so use the default value for this ssh 90 62315"
else
	address=$1;
	port=$2;
fi
ssh root@192.168.10.$address -p$port;echo " ### success ###!";
echo " ### ssh end login ###!";
echo ">"
