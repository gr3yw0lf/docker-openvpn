
DOCKERFILE_FOLDER=.
DOCKERFILE_SERVER_FOLDER=server.container
DOCKERFILE_BUILD_AUTHPAM=buildAuthPam.container
OWNER=${DOCKER_OWNER}
OWNER?=local
NAME=openvpn
VERSION=0.3.7

TAG=${OWNER}/${NAME}:${VERSION}

OPTS=--privileged=true -P -v `pwd`/certs:/etc/openvpn-nl/secure:ro

all: certsdir build tag build-server

build: Dockerfile
	docker build -t ${OWNER}/${NAME}_core:${VERSION} ${DOCKERFILE_FOLDER}

tag:
	docker tag --force ${OWNER}/${NAME}_core:${VERSION} ${OWNER}/${NAME}_core:working

build-server: ${DOCKERFILE_SERVER_FOLDER}/Dockerfile
	docker build -t ${TAG} ${DOCKERFILE_SERVER_FOLDER}

build-authPam: ${DOCKERFILE_BUILD_AUTHPAM}/Dockerfile
	docker build -t ${OWNER}/${NAME}_buildauthpam:${VERSION} ${DOCKERFILE_BUILD_AUTHPAM}
	docker run --name ${NAME}_buildauthpam -d ${OWNER}/${NAME}_buildauthpam:${VERSION} build-only && \
		docker cp ${NAME}_buildauthpam:/usr/lib/openvpn-nl/plugins/ . && \
		docker rm -v ${NAME}_buildauthpam

run-it:
	docker run ${OPTS} -it ${TAG} /bin/bash
run:
	docker run ${OPTS} -d ${TAG} 

certsdir:
	mkdir -p certs
