#!/bin/bash

address1=`docker exec blk_1 blackmore-cli getnewaddress`
address2=`docker exec blk_1 blackmore-cli getnewaddress`
address3=`docker exec blk_1 blackmore-cli getnewaddress`
address4=`docker exec blk_1 blackmore-cli getnewaddress`
address5=`docker exec blk_1 blackmore-cli getnewaddress`
address6=`docker exec blk_1 blackmore-cli getnewaddress`
address7=`docker exec blk_1 blackmore-cli getnewaddress`
address8=`docker exec blk_1 blackmore-cli getnewaddress`
address9=`docker exec blk_1 blackmore-cli getnewaddress`
address10=`docker exec blk_1 blackmore-cli getnewaddress`
address11=`docker exec blk_1 blackmore-cli getnewaddress`
address12=`docker exec blk_1 blackmore-cli getnewaddress`
address13=`docker exec blk_1 blackmore-cli getnewaddress`
address14=`docker exec blk_1 blackmore-cli getnewaddress`
address15=`docker exec blk_1 blackmore-cli getnewaddress`

for run in {1..1120}; do
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address1}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address2}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address3}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address4}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address5}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address6}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address7}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address8}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address9}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address10}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address11}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address12}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address13}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address14}
    docker exec blk_1 blackmore-cli generatetoaddress 1 ${address15}
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
