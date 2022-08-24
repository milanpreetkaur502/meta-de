SUMMARY = "Digital Entomologist"
DESCRIPTION = "This is my customized image for Digital Entomologist"

LICENSE = "MIT"

inherit core-image

#start of the resulting deployable tarball name
export IMAGE_BASENAME = "de-production-os"
MACHINE_NAME ?= "${MACHINE}"
IMAGE_NAME = "${MACHINE_NAME}_${IMAGE_BASENAME}"

SYSTEMD_DEFAULT_TARGET = "graphical.target"

IMAGE_LINGUAS = "en-us"

ROOTFS_PKGMANAGE_PKGS ?= '${@oe.utils.conditional("ONLINE_PACKAGE_MANAGEMENT", "none", "", "${ROOTFS_PKGMANAGE}", d)}'

IMAGE_FEATURES += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', '', \
       bb.utils.contains('DISTRO_FEATURES',     'x11', 'x11', \
                                                       '', d), d)} \
"

IMAGE_INSTALL_append = " \
    packagegroup-boot \
    packagegroup-basic \
    udev-extra-rules \
    ${ROOTFS_PKGMANAGE_PKGS} \
    weston weston-init wayland-terminal-launch \
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

IMAGE_DEV_MANAGER   = "udev"
IMAGE_INIT_MANAGER  = "systemd"
IMAGE_INITSCRIPTS   = " "
IMAGE_LOGIN_MANAGER = "busybox shadow"

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
