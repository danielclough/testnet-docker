#!/bin/bash

i=0
echo "Echo blockhash every min for 1 hour:"
for run in {1..60}; do
    hash=`docker exec test_1 blackmore-cli getbestblockhash`
    echo ${i}: ${hash}
        (( i++ ))
    sleep 60
done