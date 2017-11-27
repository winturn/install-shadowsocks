#! /usr/bin/env bash

# ==============================================================
# Operating System  : Centos 6+ x86_64
#                     Centos 7+ x86_64
# Author            : win turn
# Update time       ：2017-11-27 21:09:15
# ==============================================================

cd
yum -y update
yum -y install gcc
yum -y install openssl-devel
yum -y install wget

wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
tar -jxvf Python-2.7.3.tar.bz2
cd Python-2.7.3
./configure
make all
make install
mv /usr/bin/python /usr/bin/python2.6.6
ln -s /usr/local/bin/python2.7 /usr/bin/python
sed -i '1s/python/python2.6.6/' /usr/bin/yum
if [[ 'CentOS Linux release 7.2.1511 (Core) ' == *' 7.'* ]]
then
    sed -i '1s/python/python2.6.6/' /usr/libexec/urlgrabber-ext-down
fi

cd
yum -y install python-setuptools
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
easy_install pip
pip install distribute

pip install shadowsocks

IP_ADDR=`ip addr | tail -1 | awk '{print $4}'`

cat > /etc/shadowsocks.json << EOF
{
    "server":"$IP_ADDR",
    "port_password":{
         "8888":"shadowsocks",
         "9999":"shadowsocks"
         },
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open":false,
    "workers":1
}
EOF

cat >> /etc/rc.local << EOF
ssserver -c /etc/shadowsocks.json -d start
EOF

ssserver -c /etc/shadowsocks.json -d start
if [ $? -eq 0 ]
then
    echo "shadowsocks running..."
else
    echo "shadowsocks fail..."
fi

echo "
    ==========================[ shadowsocks command ]=================================
    |  start   shadowsocks server: ssserver -c /etc/shadowsocks.json -d start        |
    |  stop    shadowsocks server: ssserver -c /etc/shadowsocks.json -d stop         |
    |  restart shadowsocks server: ssserver -c /etc/shadowsocks.json -d restart      |
    ==================================================================================

    =========================[    win_turn remind   ]=================================
    |                                                                                |
    |  ip address:   $IP_ADDR                                                        |
    |                                                                                |
    |  port 1    :   8888                                                            |
    |  password 1:   shadowsocks                                                     |
    |                                                                                |
    |  port 2    :   9999                                                            |
    |  password 2:   shadowsocks                                                     |
    |                                                                                |
    ==================================================================================
"
