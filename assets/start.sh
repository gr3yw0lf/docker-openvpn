#!/bin/sh

/opt/docker-openvpn/bin/mknodTun.sh

/usr/sbin/openvpn-nl --writepid /var/run/openvpn-nl.server.pid \
		--daemon ovpn-server \
		--cd /etc/openvpn-nl \
		--config /etc/openvpn-nl/server.conf \
		--server $OPENVPN_NETWORK $OPENVPN_NETMASK

date > /var/log/openvpn/start.log
# Forces the docker to stay running
tail -F /var/log/openvpn/start.log
