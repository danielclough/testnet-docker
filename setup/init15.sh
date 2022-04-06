#!/bin/bash

address1=`docker exec blk_1 blackmore-cli getnewaddress`
address2=`docker exec blk_2 blackmore-cli getnewaddress`
address3=`docker exec blk_3 blackmore-cli getnewaddress`
address4=`docker exec blk_4 blackmore-cli getnewaddress`
address5=`docker exec blk_5 blackmore-cli getnewaddress`
address6=`docker exec blk_6 blackmore-cli getnewaddress`
address7=`docker exec blk_7 blackmore-cli getnewaddress`
address8=`docker exec blk_8 blackmore-cli getnewaddress`
address9=`docker exec blk_9 blackmore-cli getnewaddress`
address10=`docker exec blk_10 blackmore-cli getnewaddress`
address11=`docker exec blk_11 blackmore-cli getnewaddress`
address12=`docker exec blk_12 blackmore-cli getnewaddress`
address13=`docker exec blk_13 blackmore-cli getnewaddress`
address14=`docker exec blk_14 blackmore-cli getnewaddress`
address15=`docker exec blk_15 blackmore-cli getnewaddress`
wait

for run in {1..1120}; do
    docker exec blk_1 blackmore-cli generatetoaddress 4 ${address1}
    docker exec blk_2 blackmore-cli generatetoaddress 4 ${address2}
    docker exec blk_3 blackmore-cli generatetoaddress 4 ${address3}
    docker exec blk_4 blackmore-cli generatetoaddress 4 ${address4}
    docker exec blk_5 blackmore-cli generatetoaddress 4 ${address5}
    docker exec blk_6 blackmore-cli generatetoaddress 4 ${address6}
    docker exec blk_7 blackmore-cli generatetoaddress 4 ${address7}
    docker exec blk_8 blackmore-cli generatetoaddress 4 ${address8}
    docker exec blk_9 blackmore-cli generatetoaddress 4 ${address9}
    docker exec blk_10 blackmore-cli generatetoaddress 4 ${address10}
    docker exec blk_11 blackmore-cli generatetoaddress 4 ${address11}
    docker exec blk_12 blackmore-cli generatetoaddress 4 ${address12}
    docker exec blk_13 blackmore-cli generatetoaddress 4 ${address13}
    docker exec blk_14 blackmore-cli generatetoaddress 4 ${address14}
    docker exec blk_15 blackmore-cli generatetoaddress 4 ${address15}
    wait
done

docker exec blk_1 blackmore-cli getbestblockhash && \
docker exec blk_2 blackmore-cli getbestblockhash && \
docker exec blk_3 blackmore-cli getbestblockhash && \
docker exec blk_4 blackmore-cli getbestblockhash && \
docker exec blk_5 blackmore-cli getbestblockhash && \
docker exec blk_6 blackmore-cli getbestblockhash && \
docker exec blk_7 blackmore-cli getbestblockhash && \
docker exec blk_8 blackmore-cli getbestblockhash && \
docker exec blk_9 blackmore-cli getbestblockhash && \
docker exec blk_10 blackmore-cli getbestblockhash && \
docker exec blk_11 blackmore-cli getbestblockhash && \
docker exec blk_12 blackmore-cli getbestblockhash && \
docker exec blk_13 blackmore-cli getbestblockhash && \
docker exec blk_14 blackmore-cli getbestblockhash && \
docker exec blk_15 blackmore-cli getbestblockhash
