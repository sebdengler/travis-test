#!/bin/bash


# Run Docker container
if ! [ "$IN_DOCKER" ]; then

  docker pull $DOCKER_IMAGE

  docker run \
  -e IN_DOCKER=true \
  -e TRAVIS_BRANCH \
  -e TRAVIS_BUILD_DIR \
  -v $(pwd):/root/$(basename $PWD) \
  -w /root/$(basename $PWD) \
  -t \
  $DOCKER_IMAGE /root/$(basename $PWD)/./$SCRIPT

  exit
fi

: '
PROJECT_NAME="testing"
rm -rf src && mkdir -p src/${PROJECT_NAME}
mv $(ls -a | grep -Ev '^.$|^..$|^ccache$|^src$') src/${PROJECT_NAME}
ls -a
cd src
ls -a
cd testing
ls -a
'

: '
echo "ls:"
ls
echo "ls -a:"
ls -a
echo "PWD = $PWD"
git status
cd /root
echo "ls in root:"
ls
echo "ls -a in root:"
ls -a
'


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
PROJECT_NAME="testing"
URL=${TRAVIS_BUILD_DIR/"/home/travis/build"/"https://github.com"}
cd /root
mkdir -p /catkin_ws/src
git clone $URL -b $TRAVIS_BRANCH /catkin_ws/src/$PROJECT_NAME


# Initialize git submodules
cd /catkin_ws/src/$PROJECT_NAME
git submodule update --init --recursive
cd ../..

# Lint
catkin_lint -W3 .


# Make
catkin_make_isolated


# Test
