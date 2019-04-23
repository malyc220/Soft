#!/bin/bash

if [[ "$USER" != 'root' ]]; then
	echo "En este momento, es necesario ejecutar este como root"
	exit
fi
######### Make FOR @Malyc220 ##########
apt update && apt upgrade -y && apt dist-upgrade -y
apt install build-essential -y
wget http://www.softether-download.com/files/softether/v4.29-9680-rtm-2019.02.28-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz
tar -xzvf softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz
cd vpnserver && make
cd .. && mv vpnserver /usr/local/ && cd /usr/local/vpnserver/ 
chmod 600 * && chmod 700 vpnserver && chmod 700 vpncmd
cat > /etc/init.d/vpnserver <<- "EOF"
#!/bin/sh
# chkconfig: 2345 99 01
# description: SoftEther VPN Server
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0
EOF
mkdir /var/lock/subsys
chmod 755 /etc/init.d/vpnserver && /etc/init.d/vpnserver start
update-rc.d vpnserver defaults
