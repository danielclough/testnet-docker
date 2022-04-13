#!/bin/bash

nodeN=blk_1
shortWait=5
minutes=5
longWait=`echo "60 * ${minutes}" | bc`

check1=`docker exec ${nodeN} blackmore-cli getblockcount |grep error`
if [[ -n ${check1} ]];then
    echo "Syncing now, trying again in ${minutes} minutes."
    sleep ${longWait}
fi

check2=2
while ! [[ "${check1}" == "${check2}" ]];do
    echo "Testing block count."
    check1=`docker exec ${nodeN} blackmore-cli getblockcount`
    sleep ${shortWait}
    check2=`docker exec ${nodeN} blackmore-cli getblockcount`
    if ! [[ "${check1}" == "${check2}" ]];then
        echo "Trying again in ${minutes} minutes."
        sleep ${longWait}
    fi
done
echo "${nodeN} Synced"