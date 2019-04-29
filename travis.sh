#!/bin/bash

echo "in travis.sh"

if ! [ "$IN_DOCKER" ]; then
  echo "if in docker"
  docker pull $DOCKER_IMAGE
  docker run -t -d $DOCKER_IMAGE
  docker exec $(docker ps -q) bash -c "cd /home/ && git clone https://github.com/sebdengler/travis-test.git"
  docker exec $(docker ps -q) bash -c "cd /home/travis-test/ && source travis.sh"
  exit
fi

echo "in docker container"

#docker pull toposens/toposens

#docker run -t -d toposens/toposens
#docker exec $(docker ps -q) bash -c "cd /home/ && git clone https://github.com/sebdengler/travis-test.git"
#docker exec $(docker ps -q) bash -c "cd /home/travis-test/ && source ros_setup.bash"
#docker ps
