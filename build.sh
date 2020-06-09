#!/bin/bash

set -e

REPO=presidenten

IMAGE_NAME=truncate-docker-logs
IMAGE_VERSION=1.0.0

DOCKER_BUILDKIT=1 docker image build -t ${IMAGE_NAME}:${IMAGE_VERSION} .

docker image tag ${IMAGE_NAME}:${IMAGE_VERSION} ${REPO}/${IMAGE_NAME}:${IMAGE_VERSION}
docker image tag ${IMAGE_NAME}:${IMAGE_VERSION} ${REPO}/${IMAGE_NAME}:${IMAGE_VERSION}

docker image ls | grep ${IMAGE_NAME} | grep $IMAGE_VERSION
