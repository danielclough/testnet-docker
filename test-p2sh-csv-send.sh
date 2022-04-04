#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '
set -e

legacyAddress=mooXsSyaUWxCEBAfw4CoDMo8rDPCuogHzp

# # n months * 30 days * 24 hrs * 60 min * 60 sec
# seconds=$((6*30*24*60*60))
# # n weeks * 7 days * 24 hrs * 60 min * 60 sec
# seconds=$((6*7*24*60*60))
# # n days * 24 hrs * 60 min * 60 sec
# seconds=$((1*24*60*60))
# # n hrs * 60 min * 60 sec
# seconds=$((1*60*60))
# n min * 60 sec (minimum 2min)
seconds=$((2*60))

nvalue=$((${seconds}/76))

hexvalue=$(printf '%x\n' ${nvalue})
echo ${hexvalue}
relativevalue=$(printf '%x\n' $((0x$hexvalue | 0x400000)))
echo ${relativevalue}

sequence=`./integer2lehex.sh ${relativevalue}`
echo ${sequence}

# create P2SH address

firstBlock=`docker exec blk_test_1 blackmore-cli -testnet getblockcount`
futureBlock=`echo ${firstBlock} + 1 | bc`
newaddress=`docker exec blk_test_1 blackmore-cli -testnet getnewaddress`
pubkey=`docker exec blk_test_1 blackmore-cli -testnet validateaddress ${newaddress} | jq -r '.pubkey'`
# pubkeyHash=`echo -n ${pubkey} | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 | cut -d " " -f 2`
redeemScript=`/opt/btcdeb/btcc ${nvalue} OP_CHECKSEQUENCEVERIFY OP_DROP  ${pubkey} OP_CHECKSIG 2> /dev/null`
# redeemScriptHash=`echo -n ${redeemScript} | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 | cut -d " " -f 2`
# scriptPubKey=`/opt/btcdeb/btcc OP_HASH160 ${redeemScriptHash} OP_EQUAL 2> /dev/null`
# scriptPubKeyHash=`echo -n ${scriptPubKey} | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 | cut -d " " -f 2`
decodeedscript=`docker exec blk_test_1 blackmore-cli -testnet decodescript ${redeemScript}`
p2shAddress=`echo ${decodeedscript} | jq -r '.p2sh'`
docker exec blk_test_1 blackmore-cli -testnet importaddress ${redeemScript} "p2shAddress test" true true

echo -e "
futureBlock=${futureBlock}
newaddress=${newaddress}
pubkey=${pubkey}
pubkeyHash=${pubkeyHash}
redeemScript=${redeemScript}
redeemScriptHash=${redeemScriptHash}
scriptPubKey=${scriptPubKey}
p2shAddress=${p2shAddress}" > csv.txt


# send to P2SH address

unspent=`docker exec blk_test_1 blackmore-cli -testnet listunspent 1 9999 "[\"${legacyAddress}\"]"`
# echo -e "
# unspent=${unspent}
# "

utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`

amountToSend=`bash -c "echo ${amount} / 2" | bc`

recipient=${p2shAddress}
changeAddress=`docker exec blk_test_1 blackmore-cli -testnet getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
# echo "change=${change}"


rawtxhex=`docker exec blk_test_1 blackmore-cli -testnet createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'" }''' ${firstBlock}`
# echo -e "
# rawtxhex=${rawtxhex}
# "

echo -e "
sign tx 1
"

signedrawtx=`docker exec blk_test_1 blackmore-cli -testnet signrawtransaction ${rawtxhex} | jq -r '. | .hex'`
# echo -e "
# signedrawtx=${signedrawtx}
# "

echo -e "
send tx 1
"

senttx=`docker exec blk_test_1 blackmore-cli -testnet sendrawtransaction ${signedrawtx}`
# echo ${senttx}

# spend

sleep 320

unspent=`docker exec blk_test_1 blackmore-cli -testnet listunspent 1 9999 "[\"${p2shAddress}\"]"`

# echo -e "
# unspent=${unspent}
# "

# redeemScript=`echo ${unspent} | jq -r '.[0] | .redeemScript'`
utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
utxo_scriptPubKey=`echo ${unspent} | jq -r '.[0] | .scriptPubKey'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`
amountToSend=`bash -c "echo ${amount} / 2" | bc`

privkey=`docker exec blk_test_1 blackmore-cli -testnet dumpprivkey ${newaddress}`
# echo -e "
# privkey=${privkey}"


recipient=`docker exec blk_test_1 blackmore-cli -testnet getnewaddress`
changeAddress=`docker exec blk_test_1 blackmore-cli -testnet getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
# echo "change=${change}"

currentBlock=`docker exec blk_test_1 blackmore-cli -testnet getblockcount`
rawtxhex=`docker exec blk_test_1 blackmore-cli -testnet createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}''' ${currentBlock}`
# rawtxhex=`docker exec blk_test_1 blackmore-cli -testnet createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}'''`
# echo -e "
# rawtxhex=${rawtxhex}
# "

echo -e "
sign 2nd tx
"

signedrawtx=`docker exec blk_test_1 blackmore-cli -testnet signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'", "amount": '${amount}' } ]''' '["'${privkey}'"]' | jq -r '. | .hex'`
echo -e "
signedrawtx=${signedrawtx} 
" >> csv.txt

decodedtx=`docker exec blk_test_1 blackmore-cli -testnet decoderawtransaction ${signedrawtx}`
echo ${decodedtx} | jq .
echo -e "
${decodedtx}" >> csv.txt

echo - "
firstBlock=${firstBlock}
futureBlock=${futureBlock}
currentBlock=${currentBlock}"

echo -e "
send 2nd tx
"

senttx=`docker exec blk_test_1 blackmore-cli -testnet sendrawtransaction ${signedrawtx}`
echo ${senttx}