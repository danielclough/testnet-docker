#!/bin/bash

# create

echo "Check multi-sig creation and spending:"

address1=`docker exec test_1 blackmore-cli getnewaddress`
address2=`docker exec test_2 blackmore-cli getnewaddress`
address3=`docker exec test_3 blackmore-cli getnewaddress`

pubkey1=`docker exec test_1 blackmore-cli validateaddress ${address1} | jq -r '.pubkey'`
pubkey2=`docker exec test_2 blackmore-cli validateaddress ${address2} | jq -r '.pubkey'`
pubkey3=`docker exec test_3 blackmore-cli validateaddress ${address3} | jq -r '.pubkey'`

multisig=`docker exec test_1 blackmore-cli createmultisig 2 "[\"${pubkey1}\",\"${pubkey2}\",\"${pubkey1}\"]"`

echo ${multisig}
multisigAddress=`echo ${multisig} | jq -r '.address'`
redeemScript=`echo ${multisig} | jq -r '.redeemScript'`

recipient=${multisigAddress}

# send to multisigAddress

unspent=`docker exec test_1 blackmore-cli listunspent`
utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`

amountToSend=1000

changeAddress=`docker exec test_1 blackmore-cli getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
echo "change=${change}"

rawtxhex=`docker exec test_1 blackmore-cli createrawtransaction '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}' } ]''' '''{ "'${recipient}'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}'''`
docker exec test_1 blackmore-cli decoderawtransaction ${rawtxhex} 

signedtx=`docker exec test_1 blackmore-cli signrawtransaction ${rawtxhex} | jq -r '.hex'`
txhash=`docker exec test_1 blackmore-cli sendrawtransaction ${signedtx}`
echo "${txhash}"

# spend from multisig

docker exec test_1 blackmore-cli importaddress ${multisigAddress}

unspent=`docker exec test_1 blackmore-cli listunpsent`
utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
utxo_scriptPubKey=`echo ${unspent} | jq -r '.[0] | .scriptPubKey'`

amountToSend=100
recipient=`docker exec test_1 blackmore-cli getnewaddress`
changeAddress=`docker exec test_1 blackmore-cli getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
rawtxhex=`docker exec test_1 blackmore-cli createrawtransaction '''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' '''{ "'$recipient'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}'''`

privkey1=`docker exec test_1 blackmore-cli dumpprivkey ${address1}`
privkey2=`docker exec test_2 blackmore-cli dumpprivkey ${address2}`

signedrawtx1=`docker exec test_1 blackmore-cli signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'" } ]''' '["'${privkey1}'"]' | jq -r '. | .hex'`
signedrawtx2=`docker exec test_2 blackmore-cli signrawtransaction ${signedrawtx1} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'" } ]''' '["'${privkey2}'"]' | jq -r '. | .hex'`

senttx=`docker exec test_1 blackmore-cli ${sendrawtransaction}`
echo ${senttx}