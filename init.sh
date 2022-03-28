#!/bin/bash

address1=`docker exec test_1 blackmore-cli getnewaddress`
address2=`docker exec test_2 blackmore-cli getnewaddress`
address3=`docker exec test_3 blackmore-cli getnewaddress`
address4=`docker exec test_4 blackmore-cli getnewaddress`
address5=`docker exec test_5 blackmore-cli getnewaddress`

#!/bin/bash

for run in {1..120}; do
    docker exec test_1 blackmore-cli generatetoaddress 1 ${address1}
    docker exec test_1 blackmore-cli generatetoaddress 1 ${address2}
    docker exec test_1 blackmore-cli generatetoaddress 1 ${address3}
    docker exec test_1 blackmore-cli generatetoaddress 1 ${address4}
    docker exec test_1 blackmore-cli generatetoaddress 1 ${address5}
done

    docker exec test_1 blackmore-cli getbestblockhash && \
    docker exec test_2 blackmore-cli getbestblockhash && \
    docker exec test_3 blackmore-cli getbestblockhash && \
    docker exec test_4 blackmore-cli getbestblockhash && \
    docker exec test_5 blackmore-cli getbestblockhash


