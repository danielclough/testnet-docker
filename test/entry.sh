#!/bin/bash
# set -e
dir=`dirname $0`
cd ${dir}
cd ..

# wait for blk_1 to finished syncing
bash test/test-check-sync.sh

argMessage=$1
message="sh modules __${argMessage}"
startTime=`date +%s`
version=0.0.3-${startTime}
git_message=`echo "${message}__ test.${version}"`

nodesTotal=15

# init ${logfile}
logfile="log/${version}.md"
echo -e "# $(date +%D) $(date +%T) -- ${startTime}
## ${git_message} [link](https://github.com/danielclough/testnet-docker/blob/main/log/${version}.md)" | tee ${logfile}

## cleanup if restarting a test requires log refreshing/backup
# bash cleanup.sh ${logfile} ${nodesTotal}

# trap following processes into same fg for easy killing
(trap 'kill 0' SIGINT
# distribute
# bash test/distribute.sh ${logfile} ${nodesTotal} & \
# send random tx
bash test/send-random.sh ${logfile} ${nodesTotal} & \
# # dust
bash test/dust.sh ${logfile} ${nodesTotal} & \
# log to github
bash test/log.sh ${logfile} ${nodesTotal} ${git_message}
)
