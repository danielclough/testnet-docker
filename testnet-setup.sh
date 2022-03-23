#!/bin/bash

echo -e "
    *******************************************************************************************************
     sudo will be requried - you should examine the script to ensure I'm not putting something bad in here
    *******************************************************************************************************"

composeInstalled=`docker-compose -v`
if [ -n "$var" ]; then
    echo "docker-compose not installed - installing now"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
else
    echo -e "docker-compose installed - moving on \n"
fi


conf="testnet=1
server=1
listen=1
connect=172.28.1.1
connect=172.28.1.2
connect=172.28.1.3
logips=1
synctime=0
onlynet=ipv4"

mkdir /home/$USER/blackmore-test/
mkdir /home/$USER/blackmore-test/test_1
mkdir /home/$USER/blackmore-test/test_1/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_1/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_1/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_1/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_2
mkdir /home/$USER/blackmore-test/test_2/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_2/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_2/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_2/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_3
mkdir /home/$USER/blackmore-test/test_3/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_3/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_3/.blackmore/blackmore.conf
echo -e "  /home/$USER/blackmore-test/test_2/.blackmore/blackmore.conf - configured \n\n"

echo -e "configuration used:
${conf} \n"

echo "To run commands open another terminal and use:"
echo -e "docker exec test_# blackmore-cli getinfo \n"

docker-compose up