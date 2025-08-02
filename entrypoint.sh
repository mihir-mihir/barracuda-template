#!/bin/bash

# enables error signals
set -e

# source ros installation
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

# source /opt/barracuda-template/uuv_ws/devel/setup.bash

# echo whatever args were passed in
echo "Provided arguments: $@"

exec $@