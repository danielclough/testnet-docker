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
logips=1
synctime=0
onlynet=ipv4"

mkdir /home/$USER/blackmore-test/
mkdir /home/$USER/blackmore-test/test_1
mkdir /home/$USER/blackmore-test/test_1/.blackmore
mkdir /home/$USER/blackmore-test/test_1/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/chainstate /home/$USER/blackmore-test/test_1/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/blocks /home/$USER/blackmore-test/test_1/.blackmore/testnet
echo "${conf}" > /home/$USER/blackmore-test/test_1/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_1/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_1/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_2
mkdir /home/$USER/blackmore-test/test_2/.blackmore
mkdir /home/$USER/blackmore-test/test_2/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/chainstate /home/$USER/blackmore-test/test_2/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/blocks /home/$USER/blackmore-test/test_2/.blackmore/testnet
echo "${conf}" > /home/$USER/blackmore-test/test_2/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_2/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_2/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_3
mkdir /home/$USER/blackmore-test/test_3/.blackmore
mkdir /home/$USER/blackmore-test/test_3/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/chainstate /home/$USER/blackmore-test/test_3/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/blocks /home/$USER/blackmore-test/test_3/.blackmore/testnet
echo "${conf}" > /home/$USER/blackmore-test/test_3/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_3/.blackmore/blackmore.conf
echo -e "  /home/$USER/blackmore-test/test_3/.blackmore/blackmore.conf - configured \n\n"

mkdir /home/$USER/blackmore-test/test_4
mkdir /home/$USER/blackmore-test/test_4/.blackmore
mkdir /home/$USER/blackmore-test/test_4/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/chainstate /home/$USER/blackmore-test/test_4/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/blocks /home/$USER/blackmore-test/test_4/.blackmore/testnet
echo "${conf}" > /home/$USER/blackmore-test/test_4/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_4/.blackmore/blackmore.conf
echo -e "  /home/$USER/blackmore-test/test_4/.blackmore/blackmore.conf - configured \n\n"

mkdir /home/$USER/blackmore-test/test_5
mkdir /home/$USER/blackmore-test/test_5/.blackmore
mkdir /home/$USER/blackmore-test/test_5/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/chainstate /home/$USER/blackmore-test/test_5/.blackmore/testnet
sudo cp -r /home/$USER/.blackmore/testnet/blocks /home/$USER/blackmore-test/test_5/.blackmore/testnet
echo "${conf}" > /home/$USER/blackmore-test/test_5/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_5/.blackmore/blackmore.conf
echo -e "  /home/$USER/blackmore-test/test_5/.blackmore/blackmore.conf - configured \n\n"

echo -e "configuration used:
${conf} \n"

echo "To run commands open another terminal and use:"
echo -e "docker exec test_# blackmore-cli getinfo \n"

docker-compose up