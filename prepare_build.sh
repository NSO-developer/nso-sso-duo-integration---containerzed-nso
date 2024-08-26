#!/bin/bash

VER=$1
type1=$(docker images | grep cisco-nso-prod | awk '{print $1}')
type2=$(docker images | grep cisco-nso-dev | awk '{print $1}')

docker build -t mod-nso-prod:${VER}  --no-cache --network=host --build-arg type=${type1}  --build-arg ver=${VER}  --file Dockerfile .
docker build -t mod-nso-dev:${VER}  --no-cache --network=host --build-arg type=${type2}  --build-arg ver=${VER}  --file Dockerfile .