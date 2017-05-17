#!/bin/bash

set -e

# build the latest
docker build -t jasondearte/meteor-launchpad:base .
docker build -f dev.dockerfile -t jasondearte/meteor-launchpad:devbuild .
docker build -f prod.dockerfile -t jasondearte/meteor-launchpad:latest .

# create a versioned tag for the base image
docker tag jasondearte/meteor-launchpad:base jasondearte/meteor-launchpad:base-$CIRCLE_TAG

# point the other two Dockerfiles at the versioned base image
sed -i.bak "s/:base/:base-$CIRCLE_TAG/" dev.dockerfile
sed -i.bak "s/:base/:base-$CIRCLE_TAG/" prod.dockerfile

# create the versioned builds
docker build -f dev.dockerfile -t jasondearte/meteor-launchpad:devbuild-$CIRCLE_TAG .
docker build -f prod.dockerfile -t jasondearte/meteor-launchpad:$CIRCLE_TAG .

# login to Docker Hub
docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS

# push the versioned builds
docker push jasondearte/meteor-launchpad:base-$CIRCLE_TAG
docker push jasondearte/meteor-launchpad:devbuild-$CIRCLE_TAG
docker push jasondearte/meteor-launchpad:$CIRCLE_TAG

# push the latest
docker push jasondearte/meteor-launchpad:base
docker push jasondearte/meteor-launchpad:devbuild
docker push jasondearte/meteor-launchpad:latest
