##############################################
# Created from template ros2.dockerfile.jinja
##############################################

###########################################
# Base image 
###########################################
FROM nvidia/cuda:11.8.0-devel-ubuntu20.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# Install language
RUN apt-get update && apt-get install -y \
  locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*
ENV LANG en_US.UTF-8

# Install timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && rm -rf /var/lib/apt/lists/*

# Install ROS2
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    sudo \
  && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
  && apt-get update && apt-get install -y \
    ros-foxy-ros-base \
    python3-argcomplete \
  && rm -rf /var/lib/apt/lists/*

ENV ROS_DISTRO=foxy
ENV AMENT_PREFIX_PATH=/opt/ros/foxy
ENV COLCON_PREFIX_PATH=/opt/ros/foxy
ENV LD_LIBRARY_PATH=/opt/ros/foxy/lib
ENV PATH=/opt/ros/foxy/bin:$PATH
ENV PYTHONPATH=/opt/ros/foxy/lib/python3.10/site-packages
ENV ROS_PYTHON_VERSION=3
ENV ROS_VERSION=2
ENV DEBIAN_FRONTEND=

###########################################
#  Develop image 
###########################################
FROM base AS dev


ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  bash-completion \
  build-essential \
  cmake \
  gdb \
  git \
  pylint3 \
  python3-argcomplete \
  python3-colcon-common-extensions \
  python3-pip \
  python3-rosdep \
  python3-vcstool \
  vim \
  wget \
  # Install ros distro testing packages
  ros-foxy-ament-lint \
  ros-foxy-launch-testing \
  ros-foxy-launch-testing-ament-cmake \
  ros-foxy-launch-testing-ros \
  python3-autopep8 \
  && rm -rf /var/lib/apt/lists/* \
  && rosdep init || echo "rosdep already initialized" \
  # Update pydocstyle
  && pip install --upgrade pydocstyle

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  # [Optional] Add sudo support for the non-root user
  && apt-get update \
  && apt-get install -y sudo git-core bash-completion \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  # Cleanup
  && rm -rf /var/lib/apt/lists/* \
  && echo "source /usr/share/bash-completion/completions/git" >> /home/$USERNAME/.bashrc \
  && echo "if [ -f /opt/ros/${ROS_DISTRO}/setup.bash ]; then source /opt/ros/${ROS_DISTRO}/setup.bash; fi" >> /home/$USERNAME/.bashrc \
  && echo 'export MAKEFLAGS="-j 4"' >> /home/$USERNAME/.bashrc
  

ENV DEBIAN_FRONTEND=
ENV AMENT_CPPCHECK_ALLOW_SLOW_VERSIONS=1

###########################################
#  Full image 
###########################################
FROM dev AS full

ENV DEBIAN_FRONTEND=noninteractive
# Install the full release
RUN apt-get update && apt-get install -y \
  ros-foxy-desktop \
  && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=

###########################################
#  Full+Gazebo image 
###########################################
FROM full AS gazebo

ENV DEBIAN_FRONTEND=noninteractive
# Install gazebo
RUN apt-get update && apt-get install -q -y \
  lsb-release \
  wget \
  gnupg \
  sudo \
  && wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
  && apt-get update && apt-get install -q -y \
    ros-foxy-gazebo* \
  && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=

ARG USERNAME=user
RUN echo "if [ -f /usr/share/gazebo-11/setup.bash ]; then source /usr/share/gazebo-11/setup.bash; fi" >> /home/$USERNAME/.bashrc

###########################################
#  Full+Gazebo+Nvidia image 
###########################################

FROM gazebo AS gazebo-nvidia



ARG UBUNTU_RELEASE=20.04
ARG CUDA_VERSION=11.8.0
# Make all NVIDIA GPUs visible by default
ARG NVIDIA_VISIBLE_DEVICES=all
# Use noninteractive mode to skip confirmation when installing packages
ARG DEBIAN_FRONTEND=noninteractive
# All NVIDIA driver capabilities should preferably be used, check `NVIDIA_DRIVER_CAPABILITIES` inside the container if things do not work
ENV NVIDIA_DRIVER_CAPABILITIES all
# Enable AppImage execution in a container
ENV APPIMAGE_EXTRACT_AND_RUN 1
# System defaults that should not be changed
ENV XDG_RUNTIME_DIR /tmp/runtime-user
ENV PULSE_SERVER unix:/run/pulse/native
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Default environment variables (password is "mypasswd")
ENV TZ UTC
ENV SIZEW 1920
ENV SIZEH 1080
ENV REFRESH 60
ENV DPI 96
ENV CDEPTH 24
ENV VGL_DISPLAY egl
ENV PASSWD mypasswd
ENV NOVNC_ENABLE false
ENV WEBRTC_ENCODER nvh264enc
ENV WEBRTC_ENABLE_RESIZE false
ENV ENABLE_AUDIO true
ENV ENABLE_BASIC_AUTH true

# Set versions for components that should be manually checked before upgrading, other component versions are automatically determined by fetching the version online
ARG VIRTUALGL_VERSION=3.1
ARG NOVNC_VERSION=1.3.0

# Install locales to prevent X11 errors
RUN apt-get clean && \
    apt-get update && apt-get install --no-install-recommends -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install Xvfb and other important libraries or packages
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install --no-install-recommends -y \
        software-properties-common \
        alsa-base \
        alsa-utils \
        apt-transport-https \
        apt-utils \
        build-essential \
        ca-certificates \
        cups-filters \
        cups-common \
        cups-pdf \
        curl \
        file \
        wget \
        bzip2 \
        gzip \
        p7zip-full \
        xz-utils \
        zip \
        unzip \
        zstd \
        gcc \
        git \
        jq \
        make \
        python3 \
        python3-cups \
        python3-numpy \
        mlocate \
        nano \
        vim \
        htop \
        fonts-dejavu-core \
        fonts-freefont-ttf \
        fonts-noto \
        fonts-noto-cjk \
        fonts-noto-cjk-extra \
        fonts-noto-color-emoji \
        fonts-noto-hinted \
        fonts-noto-mono \
        fonts-opensymbol \
        fonts-symbola \
        fonts-ubuntu \
        libpulse0 \
        pulseaudio \
        supervisor \
        net-tools \
        libglvnd-dev \
        libglvnd-dev:i386 \
        libgl1-mesa-dev \
        libgl1-mesa-dev:i386 \
        libegl1-mesa-dev \
        libegl1-mesa-dev:i386 \
        libgles2-mesa-dev \
        libgles2-mesa-dev:i386 \
        libglvnd0 \
        libglvnd0:i386 \
        libgl1 \
        libgl1:i386 \
        libglx0 \
        libglx0:i386 \
        libegl1 \
        libegl1:i386 \
        libgles2 \
        libgles2:i386 \
        libglu1 \
        libglu1:i386 \
        libsm6 \
        libsm6:i386 \
        vainfo \
        vdpauinfo \
        pkg-config \
        mesa-utils \
        mesa-utils-extra \        
        va-driver-all \
        xserver-xorg-input-all \
        xserver-xorg-video-all \
        mesa-vulkan-drivers \
        libvulkan-dev \
        libvulkan-dev:i386 \
        libxau6 \
        libxau6:i386 \
        libxdmcp6 \
        libxdmcp6:i386 \
        libxcb1 \
        libxcb1:i386 \
        libxext6 \
        libxext6:i386 \
        libx11-6 \
        libx11-6:i386 \
        libxv1 \
        libxv1:i386 \
        libxtst6 \
        libxtst6:i386 \
        xdg-utils \
        dbus-x11 \
        libdbus-c++-1-0v5 \
        xkb-data \
        x11-xkb-utils \
        x11-xserver-utils \
        x11-utils \
        x11-apps \
        xauth \
        xbitmaps \
        xinit \
        xfonts-base \
        libxrandr-dev \
        # Install Xvfb, packages above this line should be the same between docker-nvidia-glx-desktop and docker-nvidia-egl-desktop
        xvfb && \
    # Install Vulkan utilities
    if [ "${UBUNTU_RELEASE}" \< "20.04" ]; then apt-get install --no-install-recommends -y vulkan-utils; else apt-get install --no-install-recommends -y vulkan-tools; fi && \      
    # Install Terminator with the recommended packages
    apt-get install -y terminator && \
    rm -rf /var/lib/apt/lists/* && \
    # Configure EGL manually
    mkdir -p /usr/share/glvnd/egl_vendor.d/ && \
    echo "{\n\
    \"file_format_version\" : \"1.0.0\",\n\
    \"ICD\": {\n\
        \"library_path\": \"libEGL_nvidia.so.0\"\n\
    }\n\
}" > /usr/share/glvnd/egl_vendor.d/10_nvidia.json

# Configure Vulkan manually
RUN VULKAN_API_VERSION=$(dpkg -s libvulkan1 | grep -oP 'Version: [0-9|\.]+' | grep -oP '[0-9]+(\.[0-9]+)(\.[0-9]+)') && \
    mkdir -p /etc/vulkan/icd.d/ && \
    echo "{\n\
    \"file_format_version\" : \"1.0.0\",\n\
    \"ICD\": {\n\
        \"library_path\": \"libGLX_nvidia.so.0\",\n\
        \"api_version\" : \"${VULKAN_API_VERSION}\"\n\
    }\n\
}" > /etc/vulkan/icd.d/nvidia_icd.json

# Install VirtualGL and make libraries available for preload
RUN curl -fsSL -O "https://sourceforge.net/projects/virtualgl/files/virtualgl_${VIRTUALGL_VERSION}_amd64.deb" && \
    curl -fsSL -O "https://sourceforge.net/projects/virtualgl/files/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb" && \
    apt-get update && apt-get install -y --no-install-recommends ./virtualgl_${VIRTUALGL_VERSION}_amd64.deb ./virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    rm -f "virtualgl_${VIRTUALGL_VERSION}_amd64.deb" "virtualgl32_${VIRTUALGL_VERSION}_amd64.deb" && \
    rm -rf /var/lib/apt/lists/* && \
    chmod u+s /usr/lib/libvglfaker.so && \
    chmod u+s /usr/lib/libdlfaker.so && \
    chmod u+s /usr/lib32/libvglfaker.so && \
    chmod u+s /usr/lib32/libdlfaker.so && \
    chmod u+s /usr/lib/i386-linux-gnu/libvglfaker.so && \
    chmod u+s /usr/lib/i386-linux-gnu/libdlfaker.so

# Anything below this line should be always kept the same between docker-nvidia-glx-desktop and docker-nvidia-egl-desktop

# Install KDE and other GUI packages
ENV XDG_CURRENT_DESKTOP KDE
ENV KWIN_COMPOSE N
# Use sudoedit to change protected files instead of using sudo on kate
ENV SUDO_EDITOR kate
RUN mkdir -pm755 /etc/apt/preferences.d && \
    echo "Package: firefox*\n\
Pin: release o=Ubuntu*\n\
Pin-Priority: -1" > /etc/apt/preferences.d/firefox-ppa && \
    add-apt-repository -y ppa:mozillateam/ppa && \
    apt-get update && apt-get install --no-install-recommends -y \
        kde-plasma-desktop \
        kwin-addons \
        kwin-x11 \
        kdeadmin \
        akregator \
        ark \
        baloo-kf5 \
        breeze-cursor-theme \
        breeze-icon-theme \
        debconf-kde-helper \
        colord-kde \
        desktop-file-utils \
        filelight \
        gwenview \
        hspell \
        kaddressbook \
        kaffeine \
        kate \
        kcalc \
        kcharselect \
        kdeconnect \
        kde-spectacle \
        kdf \
        kget \
        kgpg \
        khelpcenter \
        khotkeys \
        kimageformat-plugins \
        kinfocenter \
        kio-extras \
        kleopatra \
        kmail \
        kmenuedit \
        kmix \
        knotes \
        kontact \
        kopete \
        korganizer \
        krdc \
        ktimer \
        kwalletmanager \
        librsvg2-common \
        okular \
        okular-extra-backends \
        plasma-dataengines-addons \
        plasma-discover \
        plasma-runners-addons \
        plasma-wallpapers-addons \
        plasma-widgets-addons \
        plasma-workspace-wallpapers \
        qtvirtualkeyboard-plugin \
        sonnet-plugins \
        sweeper \
        systemsettings \
        xdg-desktop-portal-kde \
        kubuntu-restricted-extras \
        kubuntu-wallpapers \
        firefox \
        pavucontrol-qt \
        transmission-qt && \
    rm -rf /var/lib/apt/lists/* && \
    # Fix KDE startup permissions issues in containers
    cp -f /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit /tmp/ && \
    rm -f /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit && \
    cp -r /tmp/start_kdeinit /usr/lib/x86_64-linux-gnu/libexec/kf5/start_kdeinit && \
    rm -f /tmp/start_kdeinit


# Wine, Winetricks, Lutris, and PlayOnLinux, this process must be consistent with https://wiki.winehq.org/Ubuntu
ARG WINE_BRANCH=staging
RUN if [ "${UBUNTU_RELEASE}" \< "20.04" ]; then add-apt-repository -y ppa:cybermax-dexter/sdl2-backport; fi && \
    mkdir -pm755 /etc/apt/keyrings && curl -fsSL -o /etc/apt/keyrings/winehq-archive.key "https://dl.winehq.org/wine-builds/winehq.key" && \
    curl -fsSL -o "/etc/apt/sources.list.d/winehq-$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2).sources" "https://dl.winehq.org/wine-builds/ubuntu/dists/$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)/winehq-$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2).sources" && \
    apt-get update && apt-get install --install-recommends -y \
        winehq-${WINE_BRANCH} && \
    apt-get install --no-install-recommends -y \
        q4wine \
        playonlinux && \
    LUTRIS_VERSION=$(curl -fsSL "https://api.github.com/repos/lutris/lutris/releases/latest" | jq -r '.tag_name' | sed 's/[^0-9\.\-]*//g') && \
    curl -fsSL -O "https://github.com/lutris/lutris/releases/download/v${LUTRIS_VERSION}/lutris_${LUTRIS_VERSION}_all.deb" && \
    apt-get install --no-install-recommends -y ./lutris_${LUTRIS_VERSION}_all.deb && rm -f "./lutris_${LUTRIS_VERSION}_all.deb" && \
    rm -rf /var/lib/apt/lists/* && \
    curl -fsSL -o /usr/bin/winetricks "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" && \
    chmod 755 /usr/bin/winetricks && \
    curl -fsSL -o /usr/share/bash-completion/completions/winetricks "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion"

# Install latest selkies-gstreamer (https://github.com/selkies-project/selkies-gstreamer) build, Python application, and web application, should be consistent with selkies-gstreamer documentation
RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential \
        python3-pip \
        python3-dev \
        python3-gi \
        python3-setuptools \
        python3-wheel \
        tzdata \
        sudo \
        udev \
        xclip \
        x11-utils \
        xdotool \
        wmctrl \
        jq \
        gdebi-core \
        x11-xserver-utils \
        xserver-xorg-core \
        libopus0 \
        libgdk-pixbuf2.0-0 \
        libsrtp2-1 \
        libxdamage1 \
        libxml2-dev \
        libwebrtc-audio-processing1 \
        libcairo-gobject2 \
        pulseaudio \
        libpulse0 \
        libpangocairo-1.0-0 \
        libgirepository1.0-dev \
        libjpeg-dev \
        libvpx-dev \
        zlib1g-dev \
        x264 && \
    if [ "${UBUNTU_RELEASE}" \> "20.04" ]; then apt-get install --no-install-recommends -y xcvt; fi && \
    rm -rf /var/lib/apt/lists/* && \
    cd /opt && \
    # Automatically fetch the latest selkies-gstreamer version and install the components
    SELKIES_VERSION=$(curl -fsSL "https://api.github.com/repos/selkies-project/selkies-gstreamer/releases/latest" | jq -r '.tag_name' | sed 's/[^0-9\.\-]*//g') && \
    curl -fsSL "https://github.com/selkies-project/selkies-gstreamer/releases/download/v${SELKIES_VERSION}/selkies-gstreamer-v${SELKIES_VERSION}-ubuntu${UBUNTU_RELEASE}.tgz" | tar -zxf - && \
    curl -O -fsSL "https://github.com/selkies-project/selkies-gstreamer/releases/download/v${SELKIES_VERSION}/selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl" && pip3 install "selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl" && rm -f "selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl" && \
    curl -fsSL "https://github.com/selkies-project/selkies-gstreamer/releases/download/v${SELKIES_VERSION}/selkies-gstreamer-web-v${SELKIES_VERSION}.tgz" | tar -zxf - && \
    cd /usr/local/cuda/lib64 && sudo find . -maxdepth 1 -type l -name "*libnvrtc.so.*" -exec sh -c 'ln -snf $(basename {}) libnvrtc.so' \;

# Install the noVNC web interface and the latest x11vnc for fallback
RUN apt-get update && apt-get install --no-install-recommends -y \
        autoconf \
        automake \
        autotools-dev \
        chrpath \
        debhelper \
        git \
        jq \
        python3 \
        python3-numpy \
        libc6-dev \
        libcairo2-dev \
        libjpeg-turbo8-dev \
        libssl-dev \
        libv4l-dev \
        libvncserver-dev \
        libtool-bin \
        libxdamage-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxss-dev \
        libxtst-dev \
        libavahi-client-dev && \
    rm -rf /var/lib/apt/lists/* && \
    # Build the latest x11vnc source to avoid various errors
    git clone "https://github.com/LibVNC/x11vnc.git" /tmp/x11vnc && \
    cd /tmp/x11vnc && autoreconf -fi && ./configure && make install && cd / && rm -rf /tmp/* && \
    curl -fsSL "https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz" | tar -xzf - -C /opt && \
    mv -f "/opt/noVNC-${NOVNC_VERSION}" /opt/noVNC && \
    ln -snf /opt/noVNC/vnc.html /opt/noVNC/index.html && \
    # Use the latest Websockify source to expose noVNC
    git clone "https://github.com/novnc/websockify.git" /opt/noVNC/utils/websockify

# Add custom packages below this comment, or use FROM in a new container and replace entrypoint.sh or supervisord.conf, and set ENTRYPOINT to /usr/bin/supervisord

# Add to user a password ${PASSWD} and to assign adequate groups
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN usermod -a -G adm,audio,cdrom,dialout,dip,fax,floppy,input,lp,lpadmin,plugdev,pulse-access,scanner,sudo,tape,tty,video,voice $USERNAME && \
    chown $USERNAME:$USERNAME /home/$USERNAME && \
    echo "$USERNAME:${PASSWD}" | chpasswd && \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

# Copy scripts and configurations used to start the container
RUN curl -fsSL -o /etc/entrypoint.sh "https://raw.githubusercontent.com/andreaostuni/docker-nvidia-egl-desktop/main/entrypoint.sh"
# COPY entrypoint.sh /etc/entrypoint.sh
RUN chmod 755 /etc/entrypoint.sh
RUN curl -fsSL -o /etc/selkies-gstreamer-entrypoint.sh "https://raw.githubusercontent.com/andreaostuni/docker-nvidia-egl-desktop/main/selkies-gstreamer-entrypoint.sh"
# COPY selkies-gstreamer-entrypoint.sh /etc/selkies-gstreamer-entrypoint.sh
RUN chmod 755 /etc/selkies-gstreamer-entrypoint.sh
RUN curl -fsSL -o /etc/supervisord.conf "https://raw.githubusercontent.com/andreaostuni/docker-nvidia-egl-desktop/main/supervisord.conf"
# COPY supervisord.conf /etc/supervisord.conf
RUN chmod 755 /etc/supervisord.conf


EXPOSE 8080

USER $USERNAME
ENV SHELL /bin/bash
ENV USER=$USERNAME
WORKDIR /home/$USERNAME

ENTRYPOINT ["/usr/bin/supervisord"]
