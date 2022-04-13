#!/bin/bash

logfile=$1
nodesTotal=$2

# run ever 10 min for 24hrs 
for run in {1..144}; do
    sleep 600
    latestTime=`date +%T`

    echo -e "
# Random Send Report at ${latestTime}" | tee -a ${logfile%.md}-rndm.md
    for ((i=2;i<=nodesTotal;i++)); do
        nodeN="blk_${i}"
        balanceN=`docker exec ${nodeN} blackmore-cli getbalance`
        sendAmount=`echo "${balanceN} / 1000" | bc`
        randomNumber=`echo $[ $RANDOM % ${nodesTotal} + 1 ]`
        randomNode="blk_${randomNumber}"
        randomAddress=`docker exec ${randomNode} blackmore-cli getnewaddress`
        
        docker exec ${nodeN} blackmore-cli sendtoaddress ${randomAddress} ${sendAmount}
        echo -e "> ${nodeN} (Balance: ${balanceN}): Sending ${sendAmount} to ${randomNode} at ${randomAddress}" | tee -a ${logfile%.md}-rndm.md
    done
done