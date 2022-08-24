SUMMARY = "Fan Control App"
DESCRIPTION = "Fan Control"
LICENSE = "CLOSED"

SRC_URI = "file://fan_control_bin \
	   file://fan_control.service \
	   file://fan_control.conf \
          "

inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){        
	install -d ${D}${sbindir}/fan_control
	install -d ${D}${sysconfdir}/entomologist
	install -m 777 ${S}/fan_control.conf ${D}${sysconfdir}/entomologist
	install -m 777 ${S}/fan_control_bin ${D}${sbindir}/fan_control
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/fan_control.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE_${PN} = "fan_control.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"
