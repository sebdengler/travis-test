#!/bin/bash

echo "in travis.sh"

if ! [ "$IN_DOCKER" ]; then
  echo "if in docker"
  docker pull $DOCKER_IMAGE

  docker run -t -d \
  -e IN_DOCKER=true \
  $DOCKER_IMAGE

  docker exec $(docker ps -q) bash -c "cd /home/ && git clone https://github.com/sebdengler/travis-test.git"
  docker exec $(docker ps -q) bash -c "cd /home/travis-test/ && source travis.sh"
  exit
fi

echo "in docker container"

# ROS setup
source ros_setup.bash
