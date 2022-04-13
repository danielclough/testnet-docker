#!/bin/bash

logfile=$1
nodesTotal=$2

startTotal=`docker exec blk_1 blackmore-cli getbalance`
fee=.001

# create array
recipientArr=()
for ((j=1;j<=nodesTotal;j++));do
    nodeN="blk_${j}"
    addressN=`docker exec ${nodeN} blackmore-cli getnewaddress`
    recipientArr+=(${addressN})
    echo -e "> ${nodeN} owns ${addressN}" | tee -a ${logfile%.md}-distribute.md
done
recipientsTotal=`echo "${recipientArr[@]}" | wc -w`

txRounds=`docker exec blk_1 blackmore-cli listunspent 1000 |grep amount|wc -l`

echo -e "
### Distributing ${startTotal} across ${recipientsTotal} of ${nodesTotal} total nodes in ${txRounds} transactions." | tee -a ${logfile%.md}-distribute.md

# send funds
    unspent=`docker exec blk_1 blackmore-cli listunspent 1000`
for ((i=0;i<=txRounds;i++));do
    utxo_txid_1=`echo "${unspent}" | jq -r ".[${i}] | .txid"`
    utxo_vout_1=`echo "${unspent}" | jq -r ".[${i}] | .vout"`
    utxo_amount_1=`echo "${unspent}" | jq -r ".[${i}] | .amount"`

    utxoMinusFee=`echo "${utxo_amount_1} - ${fee}" | bc`
    amountPerNode=`echo "${utxoMinusFee} / ${recipientsTotal}" | bc`
    amountTotal=`echo "${amountPerNode} * ${recipientsTotal}" | bc`
    change=`bash -c "echo ${utxoMinusFee} - ${amountTotal}" | bc`
    changeAddress=`docker exec blk_1 blackmore-cli getrawchangeaddress`

    echo "Agent 1 will send ${amountPerNode} & get back ${change} in change address ${changeAddress}" | tee -a ${logfile%.md}-distribute.md

    # create array of addresses to attack (prepended to change address in distributeemup${i}.sh)
    fullArr=()
    for recipient in ${recipientArr[@]};do
        fullArr+=("\\\"${recipient}\\\": ${amountPerNode},")
    done

cat <<EOF > sendrawtx${i}.sh
rawtxhex=\`docker exec blk_1 blackmore-cli createrawtransaction "[{\"txid\": \"${utxo_txid_1}\",\"vout\": ${utxo_vout_1}}]" "{${fullArr[@]}\"${changeAddress}\": \"${change}\"}"\`
signedtx=\`docker exec blk_1 blackmore-cli signrawtransaction \${rawtxhex} | jq -r '.hex'\`
# docker exec blk_1 blackmore-cli decoderawtransaction \${signedtx} | tee -a ${logfile%.md}-distribute.md
distributetxhash=\`docker exec blk_1 blackmore-cli sendrawtransaction \${signedtx}\`
echo "\${distributetxhash}" | tee -a ${logfile%.md}-distribute.md
EOF
    bash sendrawtx${i}.sh
    rm sendrawtx${i}.sh
done