#!/bin/bash

dir=`cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd`
timestamp=`date +%s`
date=`date +%D`
filename="wallet1-${timestamp}.dat"
message="${date}:${timestamp}: backup ${filename}"

sudo cd ${dir}  && \
docker stop blk_1 && \
sudo cp ~/blackmore-test/test_1/.blackmore/testnet/wallet.dat ${filename} && \
docker start blk_1 && \
echo "${message}" >> ../log/backup.txt