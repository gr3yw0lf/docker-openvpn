#!/bin/sh

if [ -e ./docker.grey.conf ]; then
	. ./docker.grey.conf
	echo "$0 pulled ./docker.grey.conf"
fi

if [ "$version" = "file" ]; then
	version=$(cat ./version)
fi

docker build -t ${taghead}/${name}:${version} server.container
