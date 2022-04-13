#!/bin/bash
logfile=$1
nodesTotal=$2

while ! [[ -n ${node2Staking} ]];do
    node2Staking=`docker exec blk_2 blackmore-cli getstakinginfo | grep '"staking": true,'`
    if ! [[ -n ${node2Staking} ]];then
        echo -e "
        
        ################################################
        Node 2 not staking: waiting another 5 minutes.
        ################################################
        
        "
        sleep 300
    fi
done

# address array
echo -e "### Prepare for dust:" | tee -a ${logfile%.md}-dust.md
recipientArr=()
for ((i=2;i<=nodesTotal;i++));do
    nodeN="blk_${i}"
    addressN=`docker exec ${nodeN} blackmore-cli getnewaddress`
    recipientArr=("${recipientArr[@]}" "${addressN}")
    echo -e "address ${i} = ${addressN}
" | tee -a ${logfile%.md}-dust.md
done
recipientsTotal=`echo "${recipientArr[@]}" | wc -w`
# bulk address array
addressRounds=`echo "260 / ${nodesTotal}" | bc`
bulkRecipientArr=()
for ((j=1;j<=addressRounds;j++));do
    for ((i=2;i<=nodesTotal;i++));do
        nodeN="blk_${i}"
        addressN=`docker exec ${nodeN} blackmore-cli getnewaddress`
        bulkRecipientArr=("${bulkRecipientArr[@]}" "${addressN}")
        echo -e "address ${i} = ${addressN}" | tee -a ${logfile%.md}-dust.md
    done
done
bulkRecipientsTotal=`echo "${bulkRecipientArr[@]}" | wc -w`


for rounds in {{1..1000}};do
    unspent=`docker exec blk_1 blackmore-cli listunspent 1`
    roundsOfDust=`docker exec blk_1 blackmore-cli listunspent 1 | grep amount | wc -l`
    for ((i=0;i<=roundsOfDust;i++));do
        utxo_txid_1=`echo "${unspent}" | jq -r ".[${i}] | .txid"`
        utxo_vout_1=`echo "${unspent}" | jq -r ".[${i}] | .vout"`
        utxo_amount_1=`echo "${unspent}" | jq -r ".[${i}] | .amount"`
        if [[ -n ${utxo_amount_1} ]];then

            amountToSend=.001
            fee=.001
            utxoMinusFee=`echo "${utxo_amount_1} - ${fee}" | bc`

            bulkDustTxTotal=`echo "${amountToSend} * ${bulkRecipientsTotal}" | bc`
            dustTxTotal=`echo "${amountToSend} * ${recipientsTotal}" | bc`

            utxo_rounded=`echo ${utxo_amount_1} | awk '{print int($1)}'`
            if (( 1 < ${utxo_rounded} ));then       
                fee=.0166         
                changeAddress=`docker exec blk_1 blackmore-cli getrawchangeaddress`
                change=`bash -c "echo ${utxoMinusFee} - ${bulkDustTxTotal}" | bc`

                echo "Agent 1 will send ${bulkDustTxTotal} with a fee of ${fee} & get back ${change} in change address ${changeAddress}" | tee -a ${logfile%.md}-dust.md

                # create array of addresses to attack (prepended to change address in dustemup${i}.sh)
                fullArr=()
                for recipient in ${bulkRecipientArr[@]};do
                    fullArr+=("\\\"${recipient}\\\": 0${amountToSend},")
                done

                cat <<EOF > dustemup${i}.sh
rawtxhex=\`docker exec blk_1 blackmore-cli createrawtransaction "[{\"txid\": \"${utxo_txid_1}\",\"vout\": ${utxo_vout_1}}]" "{${fullArr[@]}\"${changeAddress}\": \"${change}\"}"\`
signedtx=\`docker exec blk_1 blackmore-cli signrawtransaction \${rawtxhex} | jq -r '.hex'\`
# docker exec blk_1 blackmore-cli decoderawtransaction \${signedtx} | tee -a ${logfile%.md}-dust.md
dusttxhash=\`docker exec blk_1 blackmore-cli sendrawtransaction \${signedtx}\`
echo "~~\${dusttxhash}~~" | tee -a ${logfile%.md}-dust.md
EOF
            else
            echo "not today"
#                 changeAddress=`docker exec blk_1 blackmore-cli getrawchangeaddress`
#                 change=`bash -c "echo ${utxoMinusFee} - ${dustTxTotal}" | bc`

#                 echo "Agent 1 will send ${dustTxTotal} with a fee of ${fee} & get back ${change} in change address ${changeAddress}" | tee -a ${logfile%.md}-dust.md

#                 # create array of addresses to attack (prepended to change address in dustemup${i}.sh)
#                 fullArr=()
#                 for recipient in ${recipientArr[@]};do
#                     fullArr+=("\\\"${recipient}\\\": 0${amountToSend},")
#                 done

#                 cat <<EOF > dustemup${i}.sh
# rawtxhex=\`docker exec blk_1 blackmore-cli createrawtransaction "[{\"txid\": \"${utxo_txid_1}\",\"vout\": ${utxo_vout_1}}]" "{${fullArr[@]}\"${changeAddress}\": \"${change}\"}"\`
# signedtx=\`docker exec blk_1 blackmore-cli signrawtransaction \${rawtxhex} | jq -r '.hex'\`
# # docker exec blk_1 blackmore-cli decoderawtransaction \${signedtx} | tee -a ${logfile%.md}-dust.md
# dusttxhash=\`docker exec blk_1 blackmore-cli sendrawtransaction \${signedtx}\`
# echo "~~\${dusttxhash}~~" | tee -a ${logfile%.md}-dust.md
# EOF
            fi

            unset utxo_amount_1

            bash dustemup${i}.sh
            rm dustemup${i}.sh
        else
            sleep 180
        fi
    done
done