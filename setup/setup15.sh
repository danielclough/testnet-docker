#!/bin/bash
echo -e "
    *******************************************************************************************************
     sudo will be requried - you should examine the script to ensure I'm not putting something bad in here
    *******************************************************************************************************"

conf="testnet=1
server=1
listen=1
connect=172.28.1.1
connect=172.28.1.2
connect=172.28.1.3
connect=172.28.1.4
connect=172.28.1.5
connect=172.28.1.6
connect=172.28.1.7
connect=172.28.1.8
connect=172.28.1.9
connect=172.28.1.10
connect=172.28.1.11
connect=172.28.1.12
connect=172.28.1.13
connect=172.28.1.14
connect=172.28.1.15
logips=1
synctime=0
onlynet=ipv4"

sudo rm -fr /home/$USER/blackmore-test/
mkdir /home/$USER/blackmore-test/

for i in {1..15};do
    mkdir /home/$USER/blackmore-test/test_${i}
    mkdir /home/$USER/blackmore-test/test_${i}/.blackmore
    sudo cp -r /home/$USER/.blackmore/testnet/chainstate /home/$USER/blackmore-test/test_${i}/.blackmore/testnet
    sudo cp -r /home/$USER/.blackmore/testnet/blocks /home/$USER/blackmore-test/test_${i}/.blackmore/testnet
    echo "${conf}" > /home/$USER/blackmore-test/test_${i}/.blackmore/blackmore.conf
    sudo chown root:root /home/$USER/blackmore-test/test_${i}/.blackmore/blackmore.conf
    echo "  /home/$USER/blackmore-test/test_${i}/.blackmore/blackmore.conf - configured"
done

# RESET IF wallet1.dat in backup/
dir=`cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd`
timestamp=`date +%s`
date=`date +%D`
filename="wallet1.dat"
message="${date}:${timestamp}: reset ${filename} - removed all other wallet.dat files"
cd ${dir}
sudo cp ../backup/wallet1.dat /home/$USER/blackmore-test/test_1/.blackmore/testnet/wallet.dat && \
echo "${message}" >> ../log/backup.txt

echo -e "configuration used:
${conf} \n"

echo "To run commands open another terminal and use:"
echo -e "docker exec test_# blackmore-cli getinfo \n"

cd ../docker
docker-compose up