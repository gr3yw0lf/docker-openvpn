#!/bin/sh

if [ -r ./docker.grey.conf ]; then
	. ./docker.grey.conf
	echo "$0 pulled ./docker.grey.conf"
fi

if [ "$version" = "file" ]; then
	version=$(cat ./version)
fi

docker build -t ${taghead}/${name}_core:${version} .
echo "dont forget to tag:"
echo " docker tag --force ${taghead}/${name}_core:${version} ${taghead}/${name}_core:working"

