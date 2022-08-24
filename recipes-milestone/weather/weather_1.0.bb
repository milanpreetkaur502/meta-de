SUMMARY = "Weather Application"
DESCRIPTION = "get weather data from sensors"
LICENSE = "CLOSED"

SRC_URI = "file://weather_bin \
	   file://weather.service \
	   "
inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){     
	install -d ${D}${sbindir}/weather
	install -m 777 ${S}/weather_bin ${D}${sbindir}/weather
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/weather.service ${D}${systemd_unitdir}/system	
}
FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"

SYSTEMD_SERVICE_${PN} = "weather.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"
