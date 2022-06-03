#!/bin/bash

IMAGE=vmunoz82/eda_tools:0.2
PLUGDEV_GID=$(cut -d: -f3 < <(getent group plugdev))
USB_MAJOR=189

# comment the following 2 lines to disable USB or DISPLAY sharing
USB_SHARING="1"
SCREEN_SHARING="1"

docker run --rm \
--user $(id -u):$(id -g) \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/group:/etc/group:ro  \
-v $HOME:/$HOME \
-w $PWD \
${SCREEN_SHARING:+ \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=$DISPLAY \
} ${USB_SHARING:+ \
--device-cgroup-rule="c ${USB_MAJOR}:* rmw" \
-v /dev/bus/usb:/dev/bus/usb \
--group-add $PLUGDEV_GID \
} \
-ti $IMAGE
