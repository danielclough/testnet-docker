#!/bin/bash

address1=`docker exec test_1 blackmore-cli getnewaddress`
docker exec test_1 blackmore-cli generatetoaddress 4 ${address1}
address2=`docker exec test_2 blackmore-cli getnewaddress`
docker exec test_2 blackmore-cli generatetoaddress 4 ${address2}
address3=`docker exec test_3 blackmore-cli getnewaddress`
docker exec test_3 blackmore-cli generatetoaddress 4 ${address3}

address1=`docker exec test_1 blackmore-cli getnewaddress`
docker exec test_1 blackmore-cli generatetoaddress 4 ${address1}
address2=`docker exec test_2 blackmore-cli getnewaddress`
docker exec test_2 blackmore-cli generatetoaddress 4 ${address2}
address3=`docker exec test_3 blackmore-cli getnewaddress`
docker exec test_3 blackmore-cli generatetoaddress 4 ${address3}

docker exec test_1 blackmore-cli getbestblockhash
docker exec test_2 blackmore-cli getbestblockhash
docker exec test_3 blackmore-cli getbestblockhash