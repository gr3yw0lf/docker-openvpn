#!/bin/bash
set -e

echo "Service: /etc/service/openvpn-nl/run"
date > /var/log/openvpn-nl.start
echo "Service: openvpn-nl starting"
/usr/sbin/openvpn-nl --writepid /var/run/openvpn-nl.server.pid \
	--cd /etc/openvpn-nl \
	--config $OPENVPN_CONFIG \
	--server $OPENVPN_NETWORK $OPENVPN_NETMASK
echo "Service: openvpn-nl stopped"

