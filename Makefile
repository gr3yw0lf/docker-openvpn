
DOCKERFILE_FOLDER=.
DOCKERFILE_SERVER_FOLDER=server.container
DOCKERFILE_BUILD_AUTHPAM=buildAuthPam.container
ifdef DOCKER_OWNER
       OWNER=${DOCKER_OWNER}
else
       OWNER=local
endif
NAME=openvpn
VERSION=$(shell cat version)

TAG=${OWNER}/${NAME}:${VERSION}

OPTS=--privileged=true -P -v `pwd`/certs:/etc/openvpn-nl/secure:ro -v `pwd`/plugins:/usr/lib/openvpn-nl/plugins:ro

all: certsdir pluginsdir build build-server
	echo "If authPam needed: run make build-authpam"

build: Dockerfile
	docker build -t ${OWNER}/${NAME}_core:${VERSION} ${DOCKERFILE_FOLDER}

tag:
	docker tag --force ${OWNER}/${NAME}_core:${VERSION} ${OWNER}/${NAME}_core:build

build-server: ${DOCKERFILE_SERVER_FOLDER}/Dockerfile
	docker build -t ${TAG} ${DOCKERFILE_SERVER_FOLDER}

build-authpam: ${DOCKERFILE_BUILD_AUTHPAM}/Dockerfile
	docker build -t ${OWNER}/${NAME}_buildauthpam:${VERSION} ${DOCKERFILE_BUILD_AUTHPAM}
	docker run --name ${NAME}_buildauthpam -d ${OWNER}/${NAME}_buildauthpam:${VERSION} build-only && \
		docker cp ${NAME}_buildauthpam:/usr/lib/openvpn-nl/plugins/ . && \
		docker stop ${NAME}_buildauthpam && \
		docker rm -v ${NAME}_buildauthpam

run-it:
	docker run ${OPTS} -it ${TAG} /bin/bash
run:
	docker run ${OPTS} -d ${TAG} 
run-authpam:
	docker run ${OPTS} -e OPENVPV_CONFIG=/etc/openvpn-nl/server-authpam.conf -d ${TAG}

certsdir:
	mkdir -p certs
pluginsdir:
	mkdir -p plugins
