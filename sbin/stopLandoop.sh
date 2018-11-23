#! /bin/bash
docker stop $(docker ps -q --filter "name=frosty_landoop")
