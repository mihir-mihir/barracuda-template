#!/bin/bash

# enables error signals
set -e

# source ros installation
# echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
# echo "[ -f ~//catkin_ws/devel/setup.bash ] && source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

# echo whatever args were passed in
echo "Provided arguments: $@"

exec $@