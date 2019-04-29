#!/bin/bash

echo "in travis.sh"

echo "1:"
ls

if ! [ "$IN_DOCKER" ]; then
  #echo "TRAVIS_BUILD_DIR_1 = $TRAVIS_BUILD_DIR"
  #echo "if in docker"
  docker pull $DOCKER_IMAGE

  docker run \
  -e IN_DOCKER=true \
  -e TRAVIS_BRANCH \
  -v $(pwd):/root/$(basename $PWD) \
  -w /root/$(basename $PWD) \
  -t \
  $DOCKER_IMAGE /root/$(basename $PWD)/./$SCRIPT

#  docker run -t -d \
#  -e IN_DOCKER=true \
#  $DOCKER_IMAGE

#  docker exec $(docker ps -q) bash -c "cd /home/ && git clone https://github.com/sebdengler/travis-test.git"
#  docker exec $(docker ps -q) bash -c "cd /home/travis-test/ && source travis.sh"

  exit
fi

echo "2:"
ls

echo "in docker container"

# Display system information
echo "##############################################"
uname -a
lsb_release -a
gcc --version
echo "CXXFLAGS = ${CXXFLAGS}"
cmake --version
echo "##############################################"

echo "TRAVIS_BRANCH = $TRAVIS_BRANCH"

# Setup ROS
source /opt/ros/$(ls /opt/ros/)/setup.bash

# Prepare workspace
#echo "TRAVIS_BUILD_DIR_2 = $TRAVIS_BUILD_DIR"
mkdir -p src
cd src
git clone https://github.com/sebdengler/travis-test.git -b $TRAVIS_BRANCH
cd travis-test
git status
#cd travis-test
cd ../..
ls

#
catkin_lint -W3 .

catkin_make_isolated






#source ros_setup.bash
