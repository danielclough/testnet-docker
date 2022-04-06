#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '
set -e

futureBlock=5869
newaddress=mvwTVR2vxrCMvRSKBAo1hvgLamYUT3ULZY
pubkey=038956e1d3871b20ddb5ab751dafef26cbb893585b915123150637f22bffa9657d
pubkeyHash=a92c3dc81ba2fca7089b8823079e1ed7ab53e2b0
redeemScript=02ed16b17576a914a92c3dc81ba2fca7089b8823079e1ed7ab53e2b088ac
redeemScriptHash=3a2ac7533a85f41f576fed15a8e4f1b4911c5a36
scriptPubKey=a9143a2ac7533a85f41f576fed15a8e4f1b4911c5a3687
p2shAddress=2MxYnRijMyX2QFPBHUC1xrrCheHvT8M8rTM

currentBlock=`docker exec test_1 blackmore-cli getblockcount`

echo -e "
futureBlock=${futureBlock}
newaddress=${newaddress}
pubkey=${pubkey}
pubkeyHash=${pubkeyHash}
redeemScript=${redeemScript}
redeemScriptHash=${redeemScriptHash}
scriptPubKey=${scriptPubKey}
p2shAddress=${p2shAddress}"

# vo1=mvjU2nGrXNmnvCLFkkB9EDES6TYQZfKjmn
# vo2=mypoeEbZ4XyRZFsYJFH4uU5hBAxU67CPju
# privkey1=`docker exec test_1 blackmore-cli dumpprivkey ${vo1}`
# privkey2=`docker exec test_1 blackmore-cli dumpprivkey ${vo2}`


# a914${redeemScriptHash}87

# docker exec test_1 blackmore-cli importaddress ${redeemScript} "p2shAddress test" true true
docker exec test_1 blackmore-cli importaddress ${scriptPubKey} "p2shAddress test" true true

decodedScript=`docker exec test_1 blackmore-cli decodescript ${redeemScript}`
echo ${decodedScript} | jq .
decodedScript=`docker exec test_1 blackmore-cli decodescript ${scriptPubKey}`
echo ${decodedScript} | jq .

unspent=`docker exec test_1 blackmore-cli listunspent 1 999999 "[\"${p2shAddress}\"]"`
echo ${unspent} | jq .

utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
utxo_scriptPubKey=`echo ${unspent} | jq -r '.[0] | .scriptPubKey'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`

amountToSend=`bash -c "echo ${amount} / 2" | bc`

recipient=`docker exec test_1 blackmore-cli getnewaddress`
changeAddress=`docker exec test_1 blackmore-cli getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
echo "change=${change}"

rawtxhex=`docker exec test_1 blackmore-cli createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}''' ${currentBlock}`
# echo -e "
# rawtxhex=${rawtxhex}
# "
decoderawtransaction=`docker exec test_1 blackmore-cli decoderawtransaction ${rawtxhex}`
echo ${decoderawtransaction} | jq .

echo -e "
sign
"

privkey=`docker exec test_1 blackmore-cli dumpprivkey ${newaddress}`
echo -e "
privkey=${privkey}"
# signedrawtx=`docker exec test_1 blackmore-cli signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'" } ]''' | jq -r '. | .hex'`
signedrawtx=`docker exec test_1 blackmore-cli signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'" } ]''' '["'${privkey}'"]' | jq -r '. | .hex'`

echo -e "
signedrawtx=${signedrawtx}
"
decoderawtransaction=`docker exec test_1 blackmore-cli decoderawtransaction ${signedrawtx}`
echo ${decoderawtransaction} | jq .

echo -e "
send tx
"

senttx=`docker exec test_1 blackmore-cli sendrawtransaction ${signedrawtx}`
echo ${senttx}