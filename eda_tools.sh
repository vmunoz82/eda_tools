#!/bin/bash

docker run --rm \
--user $(id -u):$(id -g) \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/group:/etc/group:ro  \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=$DISPLAY \
-v $HOME:/$HOME \
-w $PWD \
-ti  vmunoz82/eda_tools
