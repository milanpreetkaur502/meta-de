SUMMARY = "Light Sensor Application"
DESCRIPTION = "Light Sensor Application"
LICENSE = "CLOSED"

SRC_URI = "file://light_intensity \
	   file://light_sensor.service \
           "
inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){     
	install -d ${D}${sbindir}/light
	install -m 777 ${S}/light_intensity ${D}${sbindir}/light
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/light_sensor.service ${D}${systemd_unitdir}/system	
}

SYSTEMD_SERVICE_${PN} = "light_sensor.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"
