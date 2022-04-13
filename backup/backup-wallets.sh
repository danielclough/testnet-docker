#!/bin/bash

dir=`cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd`
timestamp=`date +%s`
date=`date +%D`

sudo cd ${dir}

for i in {1..15};do
    filename="wallet_${i}-${timestamp}.dat"
    message="${date}: backup ${filename}"
    docker stop blk_${i}
    sudo cp ~/blackmore-test/test_${i}/.blackmore/testnet/wallet.dat ${filename}
    echo "${message}" >> ../log/backup.txt
done