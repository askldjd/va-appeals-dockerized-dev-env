#!/bin/sh

#
# Test run the appeals container in isolation.
#
docker run \
    --rm \
    -it \
    -v ~/work/va:/work/va \
    --name appeals-dev \
    appeals-dev-img
