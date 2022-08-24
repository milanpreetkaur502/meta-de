SUMMARY = "Suspend Reboot Application"
DESCRIPTION = "uspend Reboot Application"
LICENSE = "CLOSED"


SRC_URI = "file://suspend-reboot.sh \
           file://suspend-reboot.service \
           "

inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){
        install -d ${D}${systemd_unitdir}/suspend-reboot
        install -m 0644 ${WORKDIR}/suspend-reboot.sh ${D}${systemd_unitdir}/suspend-reboot
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/suspend-reboot.service ${D}${systemd_unitdir}/system        
}

SYSTEMD_SERVICE_${PN} = "suspend-reboot.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

FILES_${PN} += " \
    ${systemd_unitdir}/suspend-reboot/* \
"
