#!/bin/bash

dir=`cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd`
timestamp=`date +%s`
date=`date +%D`
filename="wallet1.dat"
message="${date}:${timestamp}: reset ${filename} - removed all other wallet.dat files"

sudo ls > /dev/null && \
cd ${dir}  && \
docker stop blk_1 && \
sudo rm  ~/blackmore-test/test_1/.blackmore/testnet/wallet.dat
sudo cp ${filename} ~/blackmore-test/test_1/.blackmore/testnet/wallet.dat
docker start blk_1

for i in {2..15};do
    nodeN="blk_${i}"
    docker stop ${nodeN}
    sudo rm ~/blackmore-test/test_${i}/.blackmore/testnet/wallet.dat
    docker start ${nodeN}
done

echo "${message}" >> ../log/backup.txt