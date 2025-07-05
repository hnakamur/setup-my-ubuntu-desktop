#!/bin/sh -x
docker system prune --all --force
docker ps -a -q | xargs -r docker rm -f
docker images -q moby/buildkit | xargs -r docker rmi
docker volume rm buildx_buildkit_logunlimited0_state
