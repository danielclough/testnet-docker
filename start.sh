#!/bin/bash
# sudo check
echo -e "
    ***************************************************************************************
     sudo is requried - examine the script to ensure I'm not putting something bad in here
    ***************************************************************************************"
sudo echo "sudo enabled"

dir=`dirname $0`
cd ${dir}

sudo screen -S test-scripts bash -c 'test/entry.sh'
# bash -c 'test/entry.sh'