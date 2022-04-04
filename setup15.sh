#!/bin/bash

echo -e "
    *******************************************************************************************************
     sudo will be requried - you should examine the script to ensure I'm not putting something bad in here
    *******************************************************************************************************"

composeInstalled=`docker-compose -v`
if [ -n "$var" ]; then
    echo "docker-compose not installed - installing now"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    sudo curl \
        -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
        -o /etc/bash_completion.d/docker-compose
else
    echo -e "docker-compose installed - moving on \n"
fi


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
echo "  /home/$USER/blackmore-test/test_3/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_4
mkdir /home/$USER/blackmore-test/test_4/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_4/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_4/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_4/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_5
mkdir /home/$USER/blackmore-test/test_5/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_5/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_5/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_5/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_6
mkdir /home/$USER/blackmore-test/test_6/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_6/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_6/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_6/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_7
mkdir /home/$USER/blackmore-test/test_7/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_7/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_7/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_7/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_8
mkdir /home/$USER/blackmore-test/test_8/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_8/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_8/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_8/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_9
mkdir /home/$USER/blackmore-test/test_9/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_9/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_9/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_9/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_10
mkdir /home/$USER/blackmore-test/test_10/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_10/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_10/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_10/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_11
mkdir /home/$USER/blackmore-test/test_11/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_11/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_11/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_11/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_12
mkdir /home/$USER/blackmore-test/test_12/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_12/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_12/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_12/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_13
mkdir /home/$USER/blackmore-test/test_13/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_13/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_13/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_13/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_14
mkdir /home/$USER/blackmore-test/test_14/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_14/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_14/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_14/.blackmore/blackmore.conf - configured"

mkdir /home/$USER/blackmore-test/test_15
mkdir /home/$USER/blackmore-test/test_15/.blackmore
echo "${conf}" > /home/$USER/blackmore-test/test_15/.blackmore/blackmore.conf
sudo chown root:root /home/$USER/blackmore-test/test_15/.blackmore/blackmore.conf
echo "  /home/$USER/blackmore-test/test_15/.blackmore/blackmore.conf - configured"

echo -e "configuration used:
${conf} \n"

echo "To run commands open another terminal and use:"
echo -e "docker exec test_# blackmore-cli getinfo \n"

docker-compose up