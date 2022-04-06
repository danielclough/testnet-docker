#!/bin/bash

message="${1}"
version=0.0.1

dir=`cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd`
cd ${dir}
logfile="../log/${version}.md"

# init ${version}.md (no -a append with tee)
epoch=`date +%s`
echo "# $(date +%D) $(date +%T) -- ${epoch}" | tee ${logfile}
git_message=`echo "## ${message} - test.${version}-${epoch}" | tee -a ${logfile}`

address1=`docker exec blk_1 blackmore-cli getnewaddress`
echo "address1: ${address1}" | tee -a ${logfile}
address2=`docker exec blk_2 blackmore-cli getnewaddress`
echo "address2: ${address2}" | tee -a ${logfile}
address3=`docker exec blk_3 blackmore-cli getnewaddress`
echo "address3: ${address3}" | tee -a ${logfile}
address4=`docker exec blk_4 blackmore-cli getnewaddress`
echo "address4: ${address4}" | tee -a ${logfile}
address5=`docker exec blk_5 blackmore-cli getnewaddress`
echo "address5: ${address5}" | tee -a ${logfile}
address6=`docker exec blk_6 blackmore-cli getnewaddress`
echo "address6: ${address6}" | tee -a ${logfile}
address7=`docker exec blk_7 blackmore-cli getnewaddress`
echo "address7: ${address7}" | tee -a ${logfile}
address8=`docker exec blk_8 blackmore-cli getnewaddress`
echo "address8: ${address8}" | tee -a ${logfile}
address9=`docker exec blk_9 blackmore-cli getnewaddress`
echo "address9: ${address9}" | tee -a ${logfile}
address10=`docker exec blk_10 blackmore-cli getnewaddress`
echo "address10: ${address10}" | tee -a ${logfile}
address11=`docker exec blk_11 blackmore-cli getnewaddress`
echo "address11: ${address11}" | tee -a ${logfile}
address12=`docker exec blk_12 blackmore-cli getnewaddress`
echo "address12: ${address12}" | tee -a ${logfile}
address13=`docker exec blk_13 blackmore-cli getnewaddress`
echo "address13: ${address13}" | tee -a ${logfile}
address14=`docker exec blk_14 blackmore-cli getnewaddress`
echo "address14: ${address14}" | tee -a ${logfile}
address15=`docker exec blk_15 blackmore-cli getnewaddress`
echo "address15: ${address15}" | tee -a ${logfile}

startTotal=`docker exec blk_1 blackmore-cli getbalance`
echo "startTotal: ${startTotal}" | tee -a ${logfile}
firstTransfer=`echo "${startTotal} / 15" | bc`
echo "firstTransfer: ${firstTransfer}" | tee -a ${logfile}

echo "sending now"

docker exec blk_1 blackmore-cli sendtoaddress ${address2} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address3} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address4} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address5} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address6} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address7} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address8} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address9} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address10} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address11} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address12} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address13} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address14} ${firstTransfer}
docker exec blk_1 blackmore-cli sendtoaddress ${address15} ${firstTransfer}

sudo mv ~/blackmore-test/test_1/.blackmore/testnet/debug.log ~/blackmore-test/test_1/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_2/.blackmore/testnet/debug.log ~/blackmore-test/test_2/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_3/.blackmore/testnet/debug.log ~/blackmore-test/test_3/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_4/.blackmore/testnet/debug.log ~/blackmore-test/test_4/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_5/.blackmore/testnet/debug.log ~/blackmore-test/test_5/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_6/.blackmore/testnet/debug.log ~/blackmore-test/test_6/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_7/.blackmore/testnet/debug.log ~/blackmore-test/test_7/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_8/.blackmore/testnet/debug.log ~/blackmore-test/test_8/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_9/.blackmore/testnet/debug.log ~/blackmore-test/test_9/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_10/.blackmore/testnet/debug.log ~/blackmore-test/test_10/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_11/.blackmore/testnet/debug.log ~/blackmore-test/test_11/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_12/.blackmore/testnet/debug.log ~/blackmore-test/test_12/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_13/.blackmore/testnet/debug.log ~/blackmore-test/test_13/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_14/.blackmore/testnet/debug.log ~/blackmore-test/test_14/.blackmore/testnet/debug-BK.log 2> /dev/null
sudo mv ~/blackmore-test/test_15/.blackmore/testnet/debug.log ~/blackmore-test/test_15/.blackmore/testnet/debug-BK.log 2> /dev/null

# run ever 10 min for 24hrs 
for run in {1..144}; do
    # sleep 600
    latestTime=`date +%T`

    echo -e "
## Stake Report at ${latestTime}" | tee -a ${logfile}
    staking1=`docker exec blk_1 blackmore-cli getstakinginfo | jq .staking`
    block1=`docker exec blk_1 blackmore-cli getblockcount`
    
    blockhash1=`docker exec blk_1 blackmore-cli getbestblockhash`
    errors=`sudo cat ~/blackmore-test/test_1/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' && sleep 10`

    echo -e "${blockhash1}
    block1=${block1} (others will only log if not matching)
    staking1=${staking1} (others will only log if not staking)
    ${errors}
    " | tee -a ${logfile}
    
    staking2=`docker exec blk_2 blackmore-cli getstakinginfo | jq .staking`
    block2=`docker exec blk_2 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block2}" ];then
        blockhash2=`docker exec blk_2 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block2=${block2}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_2/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking2};then
        echo "staking2=${staking2}" | tee -a ${logfile}
    fi

    staking3=`docker exec blk_3 blackmore-cli getstakinginfo | jq .staking`
    block3=`docker exec blk_3 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block3}" ];then
        blockhash3=`docker exec blk_3 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block3=${block3}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_3/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking3};then
        echo "staking3=${staking3}" | tee -a ${logfile}
    fi

    staking4=`docker exec blk_4 blackmore-cli getstakinginfo | jq .staking`
    block4=`docker exec blk_4 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block4}" ];then
        blockhash4=`docker exec blk_4 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block4=${block4}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_4/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking4};then
        echo "staking4=${staking4}" | tee -a ${logfile}
    fi

    staking5=`docker exec blk_5 blackmore-cli getstakinginfo | jq .staking`
    block5=`docker exec blk_5 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block5}" ];then
        blockhash5=`docker exec blk_5 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block5=${block5}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_5/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking5};then
        echo "staking5=${staking5}" | tee -a ${logfile}
    fi

    staking6=`docker exec blk_6 blackmore-cli getstakinginfo | jq .staking`
    block6=`docker exec blk_6 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block6}" ];then
        blockhash6=`docker exec blk_6 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block6=${block6}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_6/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking6};then
        echo "staking6=${staking6}" | tee -a ${logfile}
    fi

    staking7=`docker exec blk_7 blackmore-cli getstakinginfo | jq .staking`
    block7=`docker exec blk_7 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block7}" ];then
        blockhash7=`docker exec blk_7 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block7=${block7}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_7/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking7};then
        echo "staking7=${staking7}" | tee -a ${logfile}
    fi

    staking8=`docker exec blk_8 blackmore-cli getstakinginfo | jq .staking`
    block8=`docker exec blk_8 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block8}" ];then
        blockhash8=`docker exec blk_8 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block8=${block8}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_8/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking8};then
        echo "staking8=${staking8}" | tee -a ${logfile}
    fi

    staking9=`docker exec blk_9 blackmore-cli getstakinginfo | jq .staking`
    block9=`docker exec blk_9 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block9}" ];then
        blockhash9=`docker exec blk_9 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block9=${block9}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_9/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking9};then
        echo "staking9=${staking9}" | tee -a ${logfile}
    fi

    staking10=`docker exec blk_10 blackmore-cli getstakinginfo | jq .staking`
    block10=`docker exec blk_10 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block10}" ];then
        blockhash10=`docker exec blk_10 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block10=${block10}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_10/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking10};then
        echo "staking10=${staking10}" | tee -a ${logfile}
    fi

    staking11=`docker exec blk_11 blackmore-cli getstakinginfo | jq .staking`
    block11=`docker exec blk_11 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block11}" ];then
        blockhash11=`docker exec blk_11 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block11=${block11}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_11/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking11};then
        echo "staking11=${staking11}" | tee -a ${logfile}
    fi

    staking12=`docker exec blk_12 blackmore-cli getstakinginfo | jq .staking`
    block12=`docker exec blk_12 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block12}" ];then
        blockhash12=`docker exec blk_12 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block12=${block12}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_12/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking12};then
        echo "staking12=${staking12}" | tee -a ${logfile}
    fi

    staking13=`docker exec blk_13 blackmore-cli getstakinginfo | jq .staking`
    block13=`docker exec blk_13 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block13}" ];then
        blockhash13=`docker exec blk_13 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block13=${block13}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_13/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking13};then
        echo "staking13=${staking13}" | tee -a ${logfile}
    fi

    staking14=`docker exec blk_14 blackmore-cli getstakinginfo | jq .staking`
    block14=`docker exec blk_14 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block14}" ];then
        blockhash14=`docker exec blk_14 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block14=${block14}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_14/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking14};then
        echo "staking14=${staking14}" | tee -a ${logfile}
    fi

    staking15=`docker exec blk_15 blackmore-cli getstakinginfo | jq .staking`
    block15=`docker exec blk_15 blackmore-cli getblockcount`
    if ! [ "${block1}" == "${block15}" ];then
        blockhash15=`docker exec blk_15 blackmore-cli getbestblockhash | tee -a ${logfile}`
        echo "block15=${block15}" | tee -a ${logfile}
        errors=`sudo cat ~/blackmore-test/test_15/.blackmore/testnet/debug.log | tail -n 30 | grep 'banned\|FAILED\|Misbehaving' | tee -a ${logfile} && sleep 10`
    fi
    if ! ${staking15};then
        echo "staking15=${staking15}" | tee -a ${logfile}
    fi
done

git add ${logfile}
git commit -m "${git_message}"
git push