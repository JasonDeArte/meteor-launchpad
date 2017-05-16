#!/bin/bash

set -e

IMAGE_NAME=${1:-"jasondearte/meteor-launchpad"}

printf "\n[-] Building $IMAGE_NAME...\n\n"

docker build -t $IMAGE_NAME:base .
docker build -f dev.dockerfile -t $IMAGE_NAME:devbuild .
docker build -f prod.dockerfile -t $IMAGE_NAME:latest .
