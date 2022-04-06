#!/bin/bash
echo "to debug use bash -x ${0}"
PS4='${LINENO}: '

# create 2 of 3 multisig

echo -e "
Check multi-sig creation and spending:
Testing creation now.
Agents 1-3 create and share pubkeys.
"

address1=`docker exec test_1 blackmore-cli getnewaddress`
address2=`docker exec test_2 blackmore-cli getnewaddress`
address3=`docker exec test_3 blackmore-cli getnewaddress`

pubkey1=`docker exec test_1 blackmore-cli validateaddress ${address1} | jq -r '.pubkey'`
pubkey2=`docker exec test_2 blackmore-cli validateaddress ${address2} | jq -r '.pubkey'`
pubkey3=`docker exec test_3 blackmore-cli validateaddress ${address3} | jq -r '.pubkey'`

echo -e "
Agents 1-3 create multisigAddress with addmultisigaddress.
"
multisigAddress1=`docker exec test_1 blackmore-cli addmultisigaddress 2 '''["'${pubkey1}'","'${pubkey2}'","'${pubkey3}'"]'''`
multisigAddress2=`docker exec test_2 blackmore-cli addmultisigaddress 2 '''["'${pubkey1}'","'${pubkey2}'","'${pubkey3}'"]'''`
multisigAddress3=`docker exec test_3 blackmore-cli addmultisigaddress 2 '''["'${pubkey1}'","'${pubkey2}'","'${pubkey3}'"]'''`

# check 
echo -e "
Agents 1-3 check to ensure address is the same. It could be different if pubkey order was not same.
"
multisigAddress=${multisigAddress1}
if [[ "${multisigAddress}" == "${multisigAddress1}" ]];then
    echo "Agent 1 - check passed"
else
    echo "check failed"
fi
if [[ "${multisigAddress}" == "${multisigAddress2}" ]];then
    echo "Agent 2 - check passed"
else
    echo "check failed"
fi
if [[ "${multisigAddress}" == "${multisigAddress3}" ]];then
    echo "Agent 3 - check passed"
else
    echo "check failed"
fi


# send to multisigAddress
recipient=${multisigAddress}
amountToSend=1000

echo -e "
Testing send to multisigAddress now.

4th party sends ${amountToSend} to ${recipient}"

txhash=`docker exec test_4 blackmore-cli sendtoaddress ${recipient} ${amountToSend}`
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

decoderawtransaction=`docker exec test_5 blackmore-cli decoderawtransaction ${rawtxhex}`
echo ${decoderawtransaction}  | jq .

echo -e "
1 signs without exposing privkey
"

signedrawtx1=`docker exec test_1 blackmore-cli signrawtransaction ${rawtxhex} | jq -r '. | .hex'`
echo -e "
signedrawtx1=${signedrawtx1}
"

echo -e "
2 signs without exposing privkey (output should be longer)
"

signedrawtx2=`docker exec test_2 blackmore-cli signrawtransaction ${signedrawtx1} | jq -r '. | .hex'`
echo -e "
signedrawtx2=${signedrawtx2}
"

decoderawtransaction=`docker exec test_5 blackmore-cli decoderawtransaction ${signedrawtx2}`
echo ${decoderawtransaction}  | jq .

echo -e "
5 sends tx signed by 1 & 2
"

senttx=`docker exec test_5 blackmore-cli sendrawtransaction ${signedrawtx2}`
echo ${senttx}

