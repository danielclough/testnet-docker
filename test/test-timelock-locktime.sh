#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '


dateInSeconds=`date +"%s"`
futureDateInSeconds=`echo "${dateInSeconds} + 120" | bc`
currentBlock=`docker exec test_1 blackmore-cli getblockcount`
futureBlock=`echo "${currentBlock} + 2" | bc`
locktime=${futureBlock}
echo -e "
Add 120 sec or 2 blocks: 
    Note: the 2hr time for spending window is greater than 120 sec, so we are using blocktime instead of relative time. 
    dateInSeconds=${dateInSeconds}
    futureDateInSeconds=${futureDateInSeconds}
    currentBlock=${currentBlock}
    futureBlock=${futureBlock}

    locktime chosen = ${locktime}
"

recipient=`docker exec test_2 blackmore-cli getnewaddress`
echo "Agent 2 reciving address ${recipient}"

unspent=`docker exec test_1 blackmore-cli listunspent 1`
utxo_txid_1=`echo "${unspent}" | jq -r '.[0] | .txid'`
utxo_vout_1=`echo "${unspent}" | jq -r '.[0] | .vout'`
utxo_amount_1=`echo "${unspent}" | jq -r '.[0] | .amount'`
utxo_txid_2=`echo "${unspent}" | jq -r '.[1] | .txid'`
utxo_vout_2=`echo "${unspent}" | jq -r '.[1] | .vout'`
utxo_amount_2=`echo "${unspent}" | jq -r '.[1] | .amount'`

amount=`echo ${utxo_amount_1} + ${utxo_amount_2}`
amountToSend=`echo "${amount} / 2" | bc`

changeAddress=`docker exec test_1 blackmore-cli getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
echo -e "
Agent 1 sends ${amountToSend} to ${recipient} & gets back ${change} in change address ${changeAddress}
"

rawtxhex=`docker exec test_1 blackmore-cli createrawtransaction '''[ { "txid": "'${utxo_txid_1}'", "vout": '${utxo_vout_1}' }, { "txid": "'${utxo_txid_2}'", "vout": '${utxo_vout_2}' } ]''' '''{ "'$recipient'": "'${amountToSend}'", "'$changeAddress'": "'${change}'" }''' ${locktime}`

signedtx=`docker exec test_1 blackmore-cli signrawtransaction ${rawtxhex} | jq -r '.hex'`

docker exec test_1 blackmore-cli sendrawtransaction ${signedtx}

echo -e "
First attempt fails because blocktime not ready.
"

sleep 180

echo -e "
Second attempt should pass.
"

docker exec test_1 blackmore-cli sendrawtransaction ${signedtx}
