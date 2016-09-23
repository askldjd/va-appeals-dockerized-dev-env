#!/bin/sh
#
# Build the appeals development image. This should be run at least
# once prior to running docker-compose.
#
docker build -t appeals-dev-img .
