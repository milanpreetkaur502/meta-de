SUMMARY = "Sleep Mode Application"
DESCRIPTION = "Sleep Mode application"
LICENSE = "CLOSED"


SRC_URI = "file://sleep_mode.sh \
           file://sleep_mode.service \
           file://sleep_mode.timer \
           file://sleep_mode.conf \
           "

inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){
	install -d ${D}${sbindir}/sleep_mode
	install -m 777 ${S}/sleep_mode.sh ${D}${sbindir}/sleep_mode
	install -d ${D}${sysconfdir}/entomologist
	install -m 777 ${S}/sleep_mode.conf ${D}${sysconfdir}/entomologist
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/sleep_mode.service ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/sleep_mode.timer ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE_${PN} = "sleep_mode.timer"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"
