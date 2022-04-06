#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '
set -e

futureBlock=52
newaddress=mgjwLaVonPygirxNmDufA92bHiL7BT5DNw
pubkey=02c1d46f9d62e26eeda55481e39346f6bd19ea6edd19f5aa588f0be22ab3356135
pubkeyHash=
redeemScript=51b2752102c1d46f9d62e26eeda55481e39346f6bd19ea6edd19f5aa588f0be22ab3356135ac
redeemScriptHash=
scriptPubKey=
p2shAddress=2Mz3Xk4QdSRnjk5TL172zBkvBHpnFyHQiw8

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

echo -e "
futureBlock=${futureBlock}
newaddress=${newaddress}
pubkey=${pubkey}
pubkeyHash=${pubkeyHash}
redeemScript=${redeemScript}
redeemScriptHash=${redeemScriptHash}
scriptPubKey=${scriptPubKey}
p2shAddress=${p2shAddress}" > csv.txt

unspent=`docker exec blk_test_1 blackmore-cli -testnet listunspent 1 9999 "[\"${p2shAddress}\"]"`

echo -e "
unspent=${unspent}
"

# redeemScript=`echo ${unspent} | jq -r '.[0] | .redeemScript'`
utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
utxo_scriptPubKey=`echo ${unspent} | jq -r '.[0] | .scriptPubKey'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`
amountToSend=`bash -c "echo ${amount} / 2" | bc`

# privkey=`docker exec blk_test_1 blackmore-cli -testnet dumpprivkey ${newaddress}`
# echo -e "
# privkey=${privkey}"


recipient=`docker exec blk_test_1 blackmore-cli -testnet getnewaddress`
changeAddress=`docker exec blk_test_1 blackmore-cli -testnet getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
# echo "change=${change}"

currentBlock=`docker exec blk_test_1 blackmore-cli -testnet getblockcount`

data=`echo -n "Blackcoin Proof of Stake" | xxd -p`
# data=`echo -n "Even this very long message, with all of this extremely important information, is still less than 60 bytes" | xxd -p`
original_string=`echo "${data}" | xxd -r -p`
bytes=`echo "${data}" | wc --bytes`

echo -e "
data=${data}

original_string=${original_string}

bytes=${bytes}"
# check that data is less than 60 bytes (burn command can do 220 bytes)

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

rawtxhex=`docker exec blk_test_1 blackmore-cli -testnet createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "sequence": '${nvalue}' } ]''' '''{ "data": "'${data}'", "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}''' ${currentBlock}`
# rawtxhex=`docker exec blk_test_1 blackmore-cli -testnet createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}'''`
# echo -e "
# rawtxhex=${rawtxhex}
# "

echo -e "
sign 2nd tx
"

signedrawtx=`docker exec blk_test_1 blackmore-cli -testnet signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'", "amount": '${amount}' } ]''' | jq -r '. | .hex'`
# signedrawtx=`docker exec blk_test_1 blackmore-cli -testnet signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'", "amount": '${amount}' } ]''' '["'${privkey}'"]' | jq -r '. | .hex'`
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