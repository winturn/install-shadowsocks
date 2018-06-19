#! /usr/bin/env bash

# ==============================================================
# Operating System  : Centos 6+ x86_64
#                     Centos 7+ x86_64
# Author            : win turn
# Update time       ：2018-6-19 16:33:09
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

cd
yum install python-setuptools
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
wget http://pypi.python.org/packages/source/d/distribute/distribute-0.6.10.tar.gz
tar zxvf distribute-0.6.10.tar.gz
cd distribute-0.6.10
python setup.py install
cd
easy_install pip
pip install shadowsocks

IP_ADDR=`ip -a address | tail -1 | awk '{print $4}'`

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
    echo "shadowsocks run success..."
else
    echo "shadowsocks run fail..."
fi

echo "
    =========================[ shadowsocks command ]======================================
    |  start shadowsocks server    : ssserver -c /etc/shadowsocks.json -d start          |
    |  close shadowsocks server    : ssserver -c /etc/shadowsocks.json -d stop           |
    |  restart shadowsocks server  : ssserver -c /etc/shadowsocks.json -d restart        |
    ======================================================================================

    =========================[    win_turn remind you   ]=================================
    |  ip地址:   $IP_ADDR
    |  端 口1:   8888
    |  密 码1:   shadowsocks
    |  端 口2:   9999
    |  密 码2:   shadowsocks
    ======================================================================================
"
