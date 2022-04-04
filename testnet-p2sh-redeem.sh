#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '
set -e

futureBlock=1040699
newaddress=mqKdNVu4TnDUPrVAcTPYRiWmtksbeorMhS
pubkey=032b95d90ee855f2c062a7b97ce9b2789d1cd3df63c19017a36e4c2f901b51903b
pubkeyHash=6b8ce2c5d83cba81493c55fb6037445f6ba3a227
redeemScript=033be10fb17576a9146b8ce2c5d83cba81493c55fb6037445f6ba3a22788ac
redeemScriptHash=acfdf3d81255e3f645f0b02ef607ae23f726fe63
scriptPubKey=a914acfdf3d81255e3f645f0b02ef607ae23f726fe6387
p2shAddress=2N91vSD53QQ9a7vbC16w9bnazQC1gaYcpvj

currentBlock=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet getblockcount`

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
# privkey1=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet dumpprivkey ${vo1}`
# privkey2=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet dumpprivkey ${vo2}`


# a914${redeemScriptHash}87

#  docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet importaddress ${redeemScript} "p2shAddress test" true true
 docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet importaddress ${scriptPubKey} "p2shAddress test" true true

decodedScript=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet decodescript ${redeemScript}`
echo ${decodedScript} | jq .
decodedScript=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet decodescript ${scriptPubKey}`
echo ${decodedScript} | jq .

unspent=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet listunspent 1 999999 "[\"${p2shAddress}\"]"`
echo ${unspent} | jq .

utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
utxo_scriptPubKey=`echo ${unspent} | jq -r '.[0] | .scriptPubKey'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`

amountToSend=`bash -c "echo ${amount} / 2" | bc`

recipient=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet getnewaddress`
changeAddress=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
echo "change=${change}"

rawtxhex=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}''' ${currentBlock}`
# echo -e "
# rawtxhex=${rawtxhex}
# "
decoderawtransaction=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet decoderawtransaction ${rawtxhex}`
echo ${decoderawtransaction} | jq .

echo -e "
sign
"

privkey=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet dumpprivkey ${newaddress}`
echo -e "
privkey=${privkey}"
# signedrawtx=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'" } ]''' | jq -r '. | .hex'`
signedrawtx=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'" } ]''' '["'${privkey}'"]' | jq -r '. | .hex'`

echo -e "
signedrawtx=${signedrawtx}
"
decoderawtransaction=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet decoderawtransaction ${signedrawtx}`
echo ${decoderawtransaction} | jq .

echo -e "
send tx
"

senttx=`docker exec blackcoin-more-api_blackmore-testnet_1 blackmore-cli -testnet sendrawtransaction ${signedrawtx}`
echo ${senttx}