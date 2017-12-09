
#!/bin/bash
# This script will install all required stuff to run a BitSend (BSD) Masternode.
# BitSend Repo : https://github.com/LIMXTEC/BitSend
# !! THIS SCRIPT NEED TO RUN AS ROOT !!
######################################################################

clear
echo "*********** Welcome to the BitSend (BSD) Masternode Setup Script ***********"
echo 'This script will install all required updates & package for Ubuntu 14.04 !'
echo 'Clone & Compile the BSD Wallet also help you on first setup and sync'
echo '****************************************************************************'
sleep 3
echo '*** Step 1/5 ***'
echo '*** Creating 2GB Swapfile ***'
sleep 1
dd if=/dev/zero of=/mnt/mybsdswap.swap bs=2M count=1000
mkswap /mnt/mybsdswap.swap
swapon /mnt/mybsdswap.swap
sleep 1
echo '*** Done 1/5 ***'
sleep 1
echo '*** Step 2/5 ***'
echo '*** Running updates and install required packages ***'
sleep 2
sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo apt-get install build-essential libtool autotools-dev autoconf pkg-config libssl-dev -y
sudo apt-get install libboost-all-dev git npm nodejs nodejs-legacy libminiupnpc-dev redis-server -y
sudo apt-get install software-properties-common -y
sudo apt-get install libevent-dev -y
add-apt-repository ppa:bitcoin/bitcoin
apt-get update -y
apt-get install libdb4.8-dev libdb4.8++-dev -y
curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh
source ~/.profile
echo '*** Done 2/5 ***'
sleep 1
echo '*** Step 3/5 ***'
echo '*** Cloning and Compiling BitSend Wallet ***'
cd
git clone --branch v0.14.0.3 https://github.com/LIMXTEC/BitSend
cd BitSend
./autogen.sh
./configure
make

cd
cd BitSend/src
strip bitsendd
cp bitsendd /usr/local/bin
/sbin/iptables -A INPUT -i eth0 -p tcp --dport 8886 -j ACCEPT
cd

echo '*** Done 3/5 ***'
sleep 2
echo '*** Step 4/5 ***'
echo '*** Configure bitsend.conf and download and import bootstrap file ***'
sleep 2

bitsendd
sleep 3

echo -n "Please Enter a STRONG Password or copy & paste the password generated for you above and Hit [ENTER]: "
read usrpas
echo -n "Please Enter your masternode genkey respond and Hit [ENTER]: "
read mngenkey

echo -e "rpcuser=bsdmasternodeservice2387645 \nrpcpassword=$usrpas \nrpcallowip=127.0.0.1 \nserver=1 \nlisten=1 \ndaemon=1 \nlogtimestamps=1 \nmasternode=1 \npromode=1 \nmasternodeprivkey=$mngenkey \naddnode=107.170.2.241 \naddnode=45.58.51.22 \naddnode=104.207.131.249 \naddnode=68.197.13.94 \naddnode=109.30.168.16 \naddnode=31.41.247.133 \naddnode=37.120.190.76 \n" > ~/.bitsend/bitsend.conf
cd .bitsend

wget https://www.mybitsend.com/bootstrap.tar.gz

tar -xvzf bootstrap.tar.gz
echo '*** Done 4/5 ***'
sleep 2
echo '*** Step 5/5 ***'
echo '*** Last Server Start also Wallet Sync ***'
echo 'After 1 minute you will see the 'getinfo' output from the RPC Server...'
bitsendd
sleep 60
bitsendd getinfo
sleep 2
echo 'Have fun with your Masternode !'
sleep 2
echo '*** Done 5/5 ***'
