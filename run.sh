#!/bin/sh

version=1
taghead=localhost

if [ -r ./docker.grey.conf ]; then
	. ./docker.grey.conf
	echo "$0 pulled ./docker.grey.conf"
fi

if [ "$version" = "file" ]; then
	version=$(cat ./version)
fi


cmd="docker run $@ \
  ${options} ${taghead}/${name}:${version} \
  ${cmd}"

echo $cmd
$cmd

