#!/bin/sh
docker run \
    --rm \
    -it \
    -v ~/work/va:/work/va \
    --name appeals-dev \
    appeals-dev-img
