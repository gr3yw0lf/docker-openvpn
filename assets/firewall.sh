#!/bin/bash

# add, if missing the POSTROUTING rule for the firewall
/sbin/iptables -L POSTROUTING -n -t nat | egrep "MASQUERADE.*$OPENVPN_NETWORK" -q || \
	/sbin/iptables -t nat -A POSTROUTING -s $OPENVPN_NETWORK/24 -d 0.0.0.0/0 -o eth0 -j MASQUERADE

