#!/bin/sh
docker system prune -f --all
docker volume rm $(docker volume ls -qf dangling=true)
