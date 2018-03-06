#! /bin/bash

if [ -x /bin/bash ]; then
	echo -n "running...!"
elif [ -u /bin/bash ]; then
	echo -n "zzzzzz"
elif [ -g /bin/bash ]; then
	echo -n "uuu"
else
	echo -n "no x file"
fi
