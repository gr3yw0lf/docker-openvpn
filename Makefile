
DOCKERFILE_FOLDER=.
DOCKERFILE_SERVER_FOLDER=server.container
DOCKERFILE_BUILD_AUTHPAM=buildAuthPam.container
OWNER=gr3yw0lf
NAME=openvpn
VERSION=$(shell cat version)

TAG=${OWNER}/${NAME}

OPTS+=--privileged=true \
	-v /var/lib/docker-data/openvpn/conf:/etc/openvpn-nl/secure:ro \
	-v /var/lib/docker-data/openvpn/plugins:/usr/lib/openvpn-nl/plugins:ro

all: certsdir pluginsdir build tag build-server
	echo "If authPam needed: run make build-authpam"

build: Dockerfile
	docker build -t ${TAG}_core:${VERSION} ${DOCKERFILE_FOLDER}

tag:
	docker tag ${TAG}_core:${VERSION} ${TAG}_core:latest

build-server: ${DOCKERFILE_SERVER_FOLDER}/Dockerfile
	docker build -t ${TAG}:${VERSION} ${DOCKERFILE_SERVER_FOLDER}

build-authpam: ${DOCKERFILE_BUILD_AUTHPAM}/Dockerfile
	docker build -t ${TAG}_buildauthpam:${VERSION} ${DOCKERFILE_BUILD_AUTHPAM}
	docker run --rm -v `pwd`/plugins:/usr/lib/openvpn-nl/plugins/ ${TAG}_buildauthpam:${VERSION}

run-it:
	docker run ${OPTS} -it ${TAG}:${VERSION} /bin/bash
run:
	docker run ${OPTS} \
	-p 1195:1194/udp \
	--name openvpn_internal \
	-d ${TAG}:${VERSION}
run-authpam:
	docker run ${OPTS} -e OPENVPV_CONFIG=/etc/openvpn-nl/server-authpam.conf \
	-p 1196:1194/udp \
	--name openvpn_external \
	-d ${TAG}:${VERSION}

certsdir:
	mkdir -p certs
pluginsdir:
	mkdir -p plugins

