FROM ros:noetic-ros-base-focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vim \
    git \
    terminator \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64' \
    && echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections \
    # && sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    && apt-get update && apt-get install -y ./vscode.deb \
    && rm -rf /var/lib/apt/lists/*

# For articulated robotics TF tutorial
RUN apt-get update && apt-get install -y \
    ros-noetic-desktop-full \
    ros-noetic-xacro ros-noetic-joint-state-publisher-gui \
    && rm -rf /var/lib/apt/lists/*

# For project dave/uuv simulator
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential cmake cppcheck curl git gnupg libeigen3-dev libgles2-mesa-dev lsb-release pkg-config protobuf-compiler python3-dbg python3-pip python3-venv qtbase5-dev ruby software-properties-common sudo wget \
    && sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros1-latest.list' \
    && sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - \
    && apt-get update \
    && DIST=noetic \
    && GAZ=gazebo11 \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ${GAZ} lib${GAZ}-dev python3-catkin-tools python3-rosdep python3-rosinstall python3-rosinstall-generator python3-vcstool ros-${DIST}-gazebo-plugins ros-${DIST}-gazebo-ros ros-${DIST}-gazebo-ros-control ros-${DIST}-gazebo-ros-pkgs ros-${DIST}-effort-controllers ros-${DIST}-geographic-info ros-${DIST}-hector-gazebo-plugins ros-${DIST}-image-view ros-${DIST}-joint-state-controller ros-${DIST}-joint-state-publisher ros-${DIST}-joy ros-${DIST}-joy-teleop ros-${DIST}-kdl-parser-py ros-${DIST}-key-teleop ros-${DIST}-move-base ros-${DIST}-moveit-commander ros-${DIST}-moveit-planners ros-${DIST}-moveit-simple-controller-manager ros-${DIST}-moveit-ros-visualization ros-${DIST}-pcl-ros ros-${DIST}-robot-localization ros-${DIST}-robot-state-publisher ros-${DIST}-ros-base ros-${DIST}-ros-controllers ros-${DIST}-rqt ros-${DIST}-rqt-common-plugins ros-${DIST}-rqt-robot-plugins ros-${DIST}-rviz ros-${DIST}-teleop-tools ros-${DIST}-teleop-twist-joy ros-${DIST}-teleop-twist-keyboard ros-${DIST}-tf2-geometry-msgs ros-${DIST}-tf2-tools ros-${DIST}-urdfdom-py ros-${DIST}-velodyne-gazebo-plugins ros-${DIST}-velodyne-simulator ros-${DIST}-xacro \
    && rm -rf /var/lib/apt/lists/*

COPY config/ /site_config/

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \ 
    && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config
# Set up sudo
RUN apt-get update \
&& apt-get install -y sudo \
&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
&& chmod 0440 /etc/sudoers.d/$USERNAME \
&& rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"] 

RUN echo "source /opt/ros/noetic/setup.bash" >> /home/ros/.bashrc \
    && echo "[ -f ~//catkin_ws/devel/setup.bash ] && source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc


CMD ["terminator"]