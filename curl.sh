#! /bin/bash
echo ">"
echo "this is a curl shell for test"
echo "USAGE: curl data url"
echo "eg:"
echo "curl.sh '{\"data\":\"1\",\"a\":\"2\"}' http://www.zf.local:9090/Order/Auto/orderCallback"

curl -H "Content-Type: application/json" -X POST  --data $1 $2

echo ">"

