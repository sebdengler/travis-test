#!/bin/bash

echo "in travis.sh"

echo "$TRAVIS_BUILD_DIR"
echo "$basename ($TRAVIS_BUILD_DIR)"
echo "$dirname ($TRAVIS_BUILD_DIR)"
GITHUB_URL="https://github.com"
URL=${TRAVIS_BUILD_DIR/"/home/travis/build"/$GITHUB_URL}
echo $URL
URL=${TRAVIS_BUILD_DIR//home/travis/build/$GITHUB_URL}
echo $URL

: '
# Run Docker container
if ! [ "$IN_DOCKER" ]; then

  docker pull $DOCKER_IMAGE

  docker run \
  -e IN_DOCKER=true \
  -e TRAVIS_BRANCH \
  -v $(pwd):/root/$(basename $PWD) \
  -w /root/$(basename $PWD) \
  -t \
  $DOCKER_IMAGE /root/$(basename $PWD)/./$SCRIPT

  exit
fi


# Display system information
echo "##############################################"
uname -a
lsb_release -a
gcc --version
echo "CXXFLAGS = ${CXXFLAGS}"
cmake --version
echo "##############################################"


# Setup ROS
source /opt/ros/$(ls /opt/ros/)/setup.bash


# Prepare workspace
mkdir -p src
git clone https://github.com/sebdengler/travis-test.git -b $TRAVIS_BRANCH src/travis_test


# Initialize git submodules
cd src/


# Lint
catkin_lint -W3 .


# Make
catkin_make_isolated


# Test





#source ros_setup.bash
'
