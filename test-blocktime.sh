#!/bin/bash

echo "Check blocktime is less than 70 seconds:"

hash1=`docker exec test_1 blackmore-cli getbestblockhash`
sleep 70
hash2=`docker exec test_1 blackmore-cli getbestblockhash`
if [[ "${hash1}" == "${hash2}" ]];then
    echo "test 1: failed"
    echo "${hash1}"
    echo "${hash2}"
else
    echo "test 1: passed"
    echo "${hash1}"
    echo "${hash2}"
fi

hash1=`docker exec test_1 blackmore-cli getbestblockhash`
sleep 70
hash2=`docker exec test_1 blackmore-cli getbestblockhash`
if [[ "${hash1}" == "${hash2}" ]];then
    echo "test 2: failed"
    echo "${hash1}"
    echo "${hash2}"
else
    echo "test 2: passed"
    echo "${hash1}"
    echo "${hash2}"
fi

hash1=`docker exec test_1 blackmore-cli getbestblockhash`
sleep 70
hash2=`docker exec test_1 blackmore-cli getbestblockhash`
if [[ "${hash1}" == "${hash2}" ]];then
    echo "test 3: failed"
    echo "${hash1}"
    echo "${hash2}"
else
    echo "test 3: passed"
    echo "${hash1}"
    echo "${hash2}"
fi