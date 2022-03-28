#!/bin/bash
# to debug use `bash -x test-multisig-createmultisig.sh`
PS4='${LINENO}: '

# create 2 of 3 multisig

echo -e "
Check multi-sig creation and spending:
Testing creation now.
Three Users create and share pubkeys.
"

address1=`docker exec test_1 blackmore-cli getnewaddress`
address2=`docker exec test_2 blackmore-cli getnewaddress`
address3=`docker exec test_3 blackmore-cli getnewaddress`

pubkey1=`docker exec test_1 blackmore-cli validateaddress ${address1} | jq -r '.pubkey'`
pubkey2=`docker exec test_2 blackmore-cli validateaddress ${address2} | jq -r '.pubkey'`
pubkey3=`docker exec test_3 blackmore-cli validateaddress ${address3} | jq -r '.pubkey'`

echo -e "
4th party collects pubkeys and creates multisig address.
"
multisig=`docker exec test_4 blackmore-cli createmultisig 2 "[\"${pubkey1}\",\"${pubkey2}\",\"${pubkey3}\"]"`

echo ${multisig}
multisigAddress=`echo ${multisig} | jq -r '.address'`
redeemScript=`echo ${multisig} | jq -r '.redeemScript'`


# send to multisigAddress
echo -e "
Testing send to multisigAddress now.

5th party sends to multisigAddress (${multisigAddress}; held by 4th)"

recipient=${multisigAddress}
amountToSend=1000
echo -e "
amountToSend=${amountToSend}
"

txhash=`docker exec test_5 blackmore-cli sendtoaddress ${recipient} ${amountToSend}`
echo -e "
txhash=${txhash}
"


# spend from multisig
echo -e "
Testing spend from multisig in 120 seconds.
"
sleep 120

echo -e "
5th agent imports multisigAddress.
"

docker exec test_5 blackmore-cli importaddress ${multisigAddress}

unspent=`docker exec test_5 blackmore-cli listunspent 1 9999999 "[\"${multisigAddress}\"]"`

echo -e "
unspent=${unspent}
"

utxo_txid=`echo ${unspent} | jq -r '.[0] | .txid'`
utxo_vout=`echo ${unspent} | jq -r '.[0] | .vout'`
utxo_scriptPubKey=`echo ${unspent} | jq -r '.[0] | .scriptPubKey'`
amount=`echo ${unspent} | jq -r '.[0] | .amount'`

amountToSend=100
recipient=`docker exec test_5 blackmore-cli getnewaddress`
changeAddress=`docker exec test_5 blackmore-cli getrawchangeaddress`
change=`bash -c "echo ${amount} - ${amountToSend} - .0001" | bc`
echo "change=${change}"
rawtxhex=`docker exec test_5 blackmore-cli createrawtransaction '''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' '''{ "'$recipient'": "'${amountToSend}'", "'${changeAddress}'": "'${change}'"}'''`
echo -e "
rawtxhex=${rawtxhex}
"

echo -e "
1 signs
"
privkey1=`docker exec test_1 blackmore-cli dumpprivkey ${address1}`
echo -e "
privkey1=${privkey1}"

signedrawtx1=`docker exec test_1 blackmore-cli signrawtransaction ${rawtxhex} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'" } ]''' '["'${privkey1}'"]' | jq -r '. | .hex'`
echo -e "
signedrawtx1=${signedrawtx1}
"

echo -e "
2 signs (output should be longer)
"

privkey2=`docker exec test_2 blackmore-cli dumpprivkey ${address2}`
echo -e "
privkey2=${privkey2}"

signedrawtx2=`docker exec test_2 blackmore-cli signrawtransaction ${signedrawtx1} '''[ { "txid": "'${utxo_txid}'", "vout": '${utxo_vout}', "scriptPubKey": "'${utxo_scriptPubKey}'", "redeemScript": "'${redeemScript}'" } ]''' '["'${privkey2}'"]' | jq -r '. | .hex'`
echo -e "
signedrawtx2=${signedrawtx2}
"

echo -e "
5 sends tx signed by 1 & 2
"

senttx=`docker exec test_5 blackmore-cli sendrawtransaction ${signedrawtx2}`
echo ${senttx}