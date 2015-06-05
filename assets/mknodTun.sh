#!/bin/sh

if [ ! -d /dev/net ]; then
    mkdir -p /dev/net
fi
if [ ! -c /dev/net/tun ]; then
	mknod /dev/net/tun c 10 200
	chmod 600 /dev/net/tun
fi

