#!/bin/bash

logfile=$1
nodesTotal=$2

for ((i=1;i==${nodesTotal};i++))
    sudo mv ~/blackmore-test/test_${i}/.blackmore/testnet/debug.log ~/blackmore-test/test_${i}/.blackmore/testnet/debug-BK.log 2> /dev/null
done