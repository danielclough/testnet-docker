#!/bin/bash

logfile=$1
nodesTotal=$2
git_message=$3

# run ever 10 min for 24hrs 
for run in {1..144}; do
    sleep 600
    latestTime=`date +%T`

    echo -e "
### Stake Report at ${latestTime}" | tee -a ${logfile%.md}-stake.md
    nodeN="blk_1"
    staking1=`docker exec blk_1 blackmore-cli getstakinginfo | jq .staking`
    block1=`docker exec blk_1 blackmore-cli getblockcount`
    blockhash1=`docker exec blk_1 blackmore-cli getbestblockhash`
    debug=`sudo cat ~/blackmore-test/test_1/.blackmore/testnet/debug.log | tail -n 10 `
    # debug=`sudo cat ~/blackmore-test/test_1/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving'`
    sleep 2
    echo -e "
> **staking1=${staking1}** (others will only log if not staking)

Node 1 is on ${block1} (others will only log if not matching)
 - ${blockhash1}
\`\`\`
debug: ${debug}
\`\`\`" | tee -a ${logfile%.md}-stake.md

    for ((i=2;i<=nodesTotal;i++));do
        nodeN="blk_${i}"
        stakingN=`docker exec ${nodeN} blackmore-cli getstakinginfo | jq .staking`
        if ! ${stakingN};then
            echo "
> **staking=${stakingN}**" | tee -a ${logfile%.md}-stake.md
        fi
        blockN=`docker exec ${nodeN} blackmore-cli getblockcount`
        if ! [ "${block1}" == "${blockN}" ];then
            blockhashN=`docker exec ${nodeN} blackmore-cli getbestblockhash`
            debug=`sudo cat ~/blackmore-test/test_${i}/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving'`
            sleep 2
            echo -e "
Node ${i} is on block ${blockN}
 - ${blockhashN}
\`\`\`
debug: ${debug}
\`\`\`" | tee -a ${logfile%.md}-stake.md
        fi
    done

    git add ${logfile%.md}*
    git commit -m "${git_message}"
    git push
done