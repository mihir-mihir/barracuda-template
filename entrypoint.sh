#!/bin/bash

# enables error signals
set -e

# source ros installation
source /opt/ros/noetic/setup.bash

# source /opt/barracuda-template/uuv_ws/devel/setup.bash

# echo whatever args were passed in
echo "Provided arguments: $@"

exec $@