#!/bin/sh -x
docker system prune --all --force
docker ps -a -q | xargs -r docker rm -f
docker images -q moby/buildkit | xargs -r docker rmi
docker volume list -q | xargs -r docker volume rm
