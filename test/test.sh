#!/bin/bash
# set -e

message="${1}"
version=0.0.1

# change "i in {n..15}" constructions below if changing
nodesTotal=15

dir=`cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd`
cd ${dir}
logfile="../log/${version}.md"

# init ${logfile} (no -a append with tee)
epoch=`date +%s`
echo "# $(date +%D) $(date +%T) -- ${epoch}" | tee ${logfile}
git_message=`echo "## ${message} - test.${version}-${epoch}" | tee -a ${logfile}`


startTotal=`docker exec blk_1 blackmore-cli getbalance`
echo -e "
startTotal: ${startTotal}" | tee -a ${logfile}
firstTransfer=`echo "${startTotal} / ${nodesTotal}" | bc`
echo -e "
firstTransfer: ${firstTransfer}" | tee -a ${logfile}

echo "sending now"
# address1=`docker exec blk_1 blackmore-cli getnewaddress`
# echo -e "
# address1: ${address1}" | tee -a ${logfile}

# for i in {2..15}; do
#     nodeN="blk_${i}"
#     addressN=`docker exec ${nodeN} blackmore-cli getnewaddress`
#     echo -e "
#     address ${i} = ${addressN}" | tee -a ${logfile}
#     docker exec blk_1 blackmore-cli sendtoaddress ${addressN} ${firstTransfer} | tee -a ${logfile}
# done

# for i in {1..15}; do
#     sudo mv ~/blackmore-test/test_${i}/.blackmore/testnet/debug.log ~/blackmore-test/test_${i}/.blackmore/testnet/debug-BK.log 2> /dev/null
# done

# run ever 10 min for 24hrs 
for run in {1..144}; do
    sleep 600
    latestTime=`date +%T`

    echo -e "
## Stake Report at ${latestTime}" | tee -a ${logfile}
    nodeN="blk_1"
    balanceN=`docker exec ${nodeN} blackmore-cli getbalance`
    sendAmount=`echo "${balanceN} / 1000" | bc`
    randomNumber=`echo $[ $RANDOM % ${nodesTotal} + 1 ]`
    randomNode="blk_${randomNumber}"
    randomAddress=`docker exec ${randomNode} blackmore-cli getnewaddress`
    docker exec ${nodeN} blackmore-cli sendtoaddress ${randomAddress} ${sendAmount}

    staking1=`docker exec blk_1 blackmore-cli getstakinginfo | jq .staking`
    block1=`docker exec blk_1 blackmore-cli getblockcount`
    
    blockhash1=`docker exec blk_1 blackmore-cli getbestblockhash`
    errors=`sudo cat ~/blackmore-test/test_1/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving'`
    sleep 2
    echo -e "> ${nodeN} (Balance: ${balanceN})
${blockhash1}
> block1=${block1} (others will only log if not matching)
> staking1=${staking1} (others will only log if not staking)
> Sending ${sendAmount} to node ${randomNumber} at ${randomAddress}
    ${errors}" | tee -a ${logfile}

    for i in {2..15}; do
        nodeN="blk_${i}"
        balanceN=`docker exec ${nodeN} blackmore-cli getbalance`
        sendAmount=`echo "${balanceN} / 1000" | bc`
        randomNumber=`echo $[ $RANDOM % ${nodesTotal} + 1 ]`
        randomNode="blk_${randomNumber}"
        randomAddress=`docker exec ${randomNode} blackmore-cli getnewaddress`
        
        docker exec ${nodeN} blackmore-cli sendtoaddress ${randomAddress} ${sendAmount}
        echo -e "
> ${nodeN} (Balance: ${balanceN})
> Sending ${sendAmount} to node ${randomNumber} at ${randomAddress}" | tee -a ${logfile}

        stakingN=`docker exec ${nodeN} blackmore-cli getstakinginfo | jq .staking`
        blockN=`docker exec ${nodeN} blackmore-cli getblockcount`
        if ! [ "${block1}" == "${blockN}" ];then
            blockhashN=`docker exec ${nodeN} blackmore-cli getbestblockhash`
            errors=`sudo cat ~/blackmore-test/test_${i}/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving'`
            sleep 2
            echo -e "${blockhashN}
> Node ${i} is on block ${blockN}
    ${errors}" | tee -a ${logfile}
        fi
        if ! ${stakingN};then
    echo "staking=${stakingN}" | tee -a ${logfile}
        fi
    done

    git add ${logfile}
    git commit -m "${git_message}"
    git push
done