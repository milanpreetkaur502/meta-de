#Append script for tdx-reference minimal
#ARV
#Toradex
#Layer meta-de

SYSTEMD_DEFAULT_TARGET = "graphical.target"

IMAGE_FEATURES += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
       bb.utils.contains('DISTRO_FEATURES',     'x11', 'x11', \
                                                       '', d), d)} \
"


IMAGE_INSTALL += " \
    packagegroup-tdx-cli \
    packagegroup-tdx-graphical \
    packagegroup-fsl-isp \
    \
    hostapd-de\
    python3 \
    python3-pillow \
    python3-pyserial \
    python3-smbus2 \
    python3-flask \
    python3-pip \
    python3-psutil \
    python3-sqlite3 \
    python3-paho-mqtt \
    python3-requests \
    git \
    device-manager \
    exfat-utils \
    fuse-exfat \
    opencv \
    cmake \
    monitor \
    camera \
    cloud \ 
    provision \
    jobreceiver \
    network \
    networkled \
    synchronizer \
    dev-verification \
    led-verification \
    systeminfo-ram \
    systeminfo-sd \
    light \
    met \
    power \
    weather \
    gps \
    fan-control \
    rana \
    4g \
    jq \
    nano \
    bc \ 
    gcc \
    watch \
    statescripts \
    ffmpeg \
    ota \
    ssh \
    aws-crt-python \
    aws-iot-device-sdk-python-v2 \
    aws-c-mqtt \
    bash \
    coreutils \
    less \
    makedevs \
    mime-support \
    util-linux \
    v4l-utils \
    gpicview \
    media-files \
    modemmanager \
    networkmanager \
    vnstat \
"

IMAGE_INSTALL_remove = " connman"
IMAGE_INSTALL_remove = " connman-client"
IMAGE_INSTALL_remove = " connman-gnome"
IMAGE_INSTALL_remove = " connman-plugin-wifi"
IMAGE_INSTALL_remove = " connman-plugin-ethernet"
IMAGE_INSTALL_remove = " connman-plugin-loopback"
PACKAGECONFIG_append_pn-networkmanager = " modemmanager ppp"

change_mod() {
	ln -nsf /usr/share/zoneinfo/Asia/Kolkata ${IMAGE_ROOTFS}/etc/localtime 
	echo -n "RuntimeWatchdogSec=30" >> ${IMAGE_ROOTFS}/etc/systemd/system.conf
	echo -n "\nRebootWatchdogSec=2min" >> ${IMAGE_ROOTFS}/etc/systemd/system.conf
	echo -n "\nShutdownWatchdogSec=2min" >> ${IMAGE_ROOTFS}/etc/systemd/system.conf
}

ROOTFS_POSTPROCESS_COMMAND += " change_mod;"
