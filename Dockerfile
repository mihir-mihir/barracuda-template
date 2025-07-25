FROM ros:noetic-ros-base-focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vim \
    git \
    terminator \
    rviz \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64' \
    && echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections \
    && apt-get update && apt-get install -y ./vscode.deb \
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

CMD ["terminator"]