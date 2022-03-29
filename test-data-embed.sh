#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '

start_data=`echo "Even this very long message, with all of this extremely important information, is still less than 220 bytes" | xxd -p`
# remove newline "0a"
op_return_data="${start_data::-2}"
reversed=`echo "${op_return_data}" | xxd -r -p`
echo "op_return_data=${op_return_data}"
# check that op_return_data is less than 220 bytes
bytes=`echo "${op_return_data}" | wc --bytes`

if (( ${bytes} < 220 ));then
    echo "
    check bytes less than 220 pass
    "
else
    echo "
    check bytes less than 220 fail
    "
    exit
fi

unspent=`docker exec test_1 blackmore-cli listunspent 1`
utxo_txid_1=`echo "${unspent}" | jq -r '.[0] | .txid'`
utxo_vout_1=`echo "${unspent}" | jq -r '.[0] | .vout'`
utxo_amount_1=`echo "${unspent}" | jq -r '.[0] | .amount'`

amount=`echo ${utxo_amount_1}`

changeAddress=`docker exec test_1 blackmore-cli getrawchangeaddress`
change=`echo "${amount} - .0001" | bc`

echo "Agent 1 sends ${op_return_data} which is ${bytes} bytes, 
the decoded string is \"${reversed}\",
& Agent 1 gets back ${change} in change address ${changeAddress}"

rawtxhex=`docker exec test_1 blackmore-cli createrawtransaction '''[ { "txid": "'${utxo_txid_1}'", "vout": '${utxo_vout_1}' } ]''' '''{ "data": "'${op_return_data}'", "'${changeAddress}'": "'${change}'" }'''`

decodedtx=`docker exec test_1 blackmore-cli decoderawtransaction ${rawtxhex}`
echo ${decodedtx} | jq .

signedtx=`docker exec test_1 blackmore-cli signrawtransaction ${rawtxhex} | jq -r '.hex'`
docker exec test_1 blackmore-cli sendrawtransaction ${signedtx}