SUMMARY = "Weather Application"
DESCRIPTION = "Weather Application"
LICENSE = "CLOSED"

SRC_URI = "file://temperature_sensor.service \
	   file://TH_reading \
           "
inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){     
	install -d ${D}${sbindir}/met
	install -m 777 ${S}/TH_reading ${D}${sbindir}/met
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/temperature_sensor.service ${D}${systemd_unitdir}/system
	
}

SYSTEMD_SERVICE_${PN} = "temperature_sensor.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"
