#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '
set -e

op_return_data=`echo -n "d82bd68bb006944567b00515b98ebad16abc1987"`
original_string=`echo "${op_return_data}" | xxd -r -p`
og_data_hex=`echo -n ${original_string} | xxd -p`
# op_return_data=`echo -n "Even this very long message, with all of this extremely important information, is still less than 60 bytes" | xxd -p`
bytes=`echo "${op_return_data}" | wc --bytes`

echo -e "
op_return_data=${op_return_data}
og_data_hex=${og_data_hex}
original_string=${original_string}

bytes=${bytes}"
# check that op_return_data is less than 60 bytes (burn command can do 220 bytes)

if (( ${bytes} < 60 ));then
    echo "
    check bytes less than 60 pass
    "
else
    echo "
    check bytes less than 60 fail
    "
    exit
fi

unspent=`docker exec blk_test_1 blackmore-cli listunspent 1`
utxo_txid_1=`echo "${unspent}" | jq -r '.[0] | .txid'`
utxo_vout_1=`echo "${unspent}" | jq -r '.[0] | .vout'`
utxo_amount_1=`echo "${unspent}" | jq -r '.[0] | .amount'`

amount=`echo ${utxo_amount_1}`
changeAddress=`docker exec blk_test_1 blackmore-cli getrawchangeaddress`
change=`echo "${amount} - .0001" | bc`

echo -e "Agent 1 sends tx gets back ${change} in change address ${changeAddress}
"

rawtxhex=`docker exec blk_test_1 blackmore-cli createrawtransaction '''[ { "txid": "'${utxo_txid_1}'", "vout": '${utxo_vout_1}' } ]''' '''{ "data": "'${op_return_data}'", "'${changeAddress}'": "'${change}'" }'''`

decodedtx=`docker exec blk_test_1 blackmore-cli decoderawtransaction ${rawtxhex}`
echo ${decodedtx} | jq .

signedtx=`docker exec blk_test_1 blackmore-cli signrawtransaction ${rawtxhex} | jq -r '.hex'`
docker exec blk_test_1 blackmore-cli sendrawtransaction ${signedtx}