#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '
set -e

# create P2SH address

firstBlock=`docker exec blk_test_1 blackmore-cli getblockcount`
futureBlock=`echo ${firstBlock} + 1 | bc`
newaddress=`docker exec blk_test_1 blackmore-cli getnewaddress`
pubkey=`docker exec blk_test_1 blackmore-cli validateaddress ${newaddress} | jq -r '.pubkey'`
pubkeyHash=`echo -n ${pubkey} | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 | cut -d " " -f 2`
redeemScript=`docker exec blk_test_1 btcc ${futureBlock} OP_CHECKLOCKTIMEVERIFY OP_DROP OP_DUP OP_HASH160 ${pubkeyHash} OP_EQUALVERIFY OP_CHECKSIG 2> /dev/null`
redeemScriptHash=`echo -n ${redeemScript} | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 | cut -d " " -f 2`
scriptPubKey=`docker exec blk_test_1 btcc OP_HASH160 ${redeemScriptHash} OP_EQUAL 2> /dev/null`
scriptPubKeyHash=`echo -n ${scriptPubKey} | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 | cut -d " " -f 2`
p2shAddress=`docker exec blk_test_1 blackmore-cli decodescript ${scriptPubKey} | jq -r '.addresses[0]'`
docker exec blk_test_1 blackmore-cli importaddress ${scriptPubKey} "p2shAddress test" true true

echo -e "
futureBlock=${futureBlock}
newaddress=${newaddress}
pubkey=${pubkey}
pubkeyHash=${pubkeyHash}
redeemScript=${redeemScript}
redeemScriptHash=${redeemScriptHash}
scriptPubKey=${scriptPubKey}
p2shAddress=${p2shAddress}" > cltv.txt


# send to P2SH address

unspent=`docker exec blk_test_1 blackmore-cli listunspent 2000`
# echo -e "
# unspent=${unspent}
# "

utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`

amountToSend=`bash -c "echo ${amount} / 2" | bc`

recipient=${p2shAddress}
changeAddress=`docker exec blk_test_1 blackmore-cli getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
echo "change=${change}"


rawtxhex=`docker exec blk_test_1 blackmore-cli createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'" }'''`
echo -e "
rawtxhex=${rawtxhex}
"

echo -e "
sign 1st tx
"

signedrawtx=`docker exec blk_test_1 blackmore-cli signrawtransaction ${rawtxhex} | jq -r '. | .hex'`
echo -e "
signedrawtx=${signedrawtx}
"

echo -e "
send tx 1st tx
"

senttx=`docker exec blk_test_1 blackmore-cli sendrawtransaction ${signedrawtx}`
echo ${senttx}

# spend

sleep 90

unspent=`docker exec blk_test_1 blackmore-cli listunspent 0 9 "[\"${p2shAddress}\"]"`

echo -e "
unspent=${unspent}
"

# redeemScript=`echo ${unspent} | jq -r '.[0] | .redeemScript'`
utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
utxo_scriptPubKey=`echo ${unspent} | jq -r '.[0] | .scriptPubKey'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`
amountToSend=`bash -c "echo ${amount} / 2" | bc`

privkey=`docker exec blk_test_1 blackmore-cli dumpprivkey ${newaddress}`
echo -e "
privkey=${privkey}"


recipient=`docker exec blk_test_1 blackmore-cli getnewaddress`
changeAddress=`docker exec blk_test_1 blackmore-cli getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
echo "change=${change}"

currentBlock=`docker exec blk_test_1 blackmore-cli getblockcount`
rawtxhex=`docker exec blk_test_1 blackmore-cli createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}''' ${currentBlock}`
echo -e "
rawtxhex=${rawtxhex}
"

echo -e "
sign 2nd tx
"

signedrawtx=`docker exec blk_test_1 blackmore-cli signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'", "amount": '${amount}' } ]''' '["'${privkey}'"]' | jq -r '. | .hex'`
echo -e "
signedrawtx=${signedrawtx}
" >> cltv.txt

decodedtx=`docker exec blk_test_1 blackmore-cli decoderawtransaction ${signedrawtx}`
echo -e "
decodedtx=${decodedtx}
" >> cltv.txt
echo ${decodedtx} | jq .

echo - "
firstBlock=${firstBlock}
futureBlock=${futureBlock}
currentBlock=${currentBlock}"

echo -e "
send tx
"

senttx=`docker exec blk_test_1 blackmore-cli sendrawtransaction ${signedrawtx}`
echo ${senttx}