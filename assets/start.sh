#!/bin/bash
set -e

/opt/docker-openvpn/bin/mknodTun.sh
/sbin/iptables -t nat -A POSTROUTING -s $OPENVPN_NETWORK/24 -d 0.0.0.0/0 -o eth0 -j MASQUERADE

if [ "$1" == "openvpn" ]; then
	/usr/sbin/openvpn-nl --writepid /var/run/openvpn-nl.server.pid \
		--daemon ovpn-server \
		--cd /etc/openvpn-nl \
		--config /etc/openvpn-nl/server.conf \
		--server $OPENVPN_NETWORK $OPENVPN_NETMASK

	echo date > /var/log/openvpn/start.log
	# Forces the docker to stay running, but not fill it's log
	tail -F /var/log/openvpn/start.log
	exit;
fi
if [ "$1" == "openvpn-authpam" ]; then
	# bring PAM config active
	cp /opt/docker-openvpn/bin/openvpn-auth-pam /etc/pam.d/openvpn

	/usr/sbin/openvpn-nl --writepid /var/run/openvpn-nl.server.pid \
		--daemon ovpn-server \
		--cd /etc/openvpn-nl \
		--config /etc/openvpn-nl/server-authpam.conf \
		--server $OPENVPN_NETWORK $OPENVPN_NETMASK

	echo date > /var/log/openvpn/start.log
	# Forces the docker to stay running, but not fill it's log
	tail -F /var/log/openvpn/start.log
	exit;
fi


exec "$@"
