
DOCKERFILE_FOLDER=.
DOCKERFILE_SERVER_FOLDER=server.container
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

run-it:
	docker run ${OPTS} -it ${TAG} /bin/bash
run:
	docker run ${OPTS} -d ${TAG} 

certsdir:
	mkdir -p certs
