SUMMARY = "Power Check Application"
DESCRIPTION = "Power Check Application"
LICENSE = "CLOSED"

SRC_URI = "file://battery_parameters \
	   file://battery_parameters.service \
	   file://gauge_configure \
	   file://gauge_configure.service \
	   "
inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){     
	install -d ${D}${sbindir}/power
	install -m 777 ${S}/battery_parameters ${D}${sbindir}/power
	install -m 777 ${S}/gauge_configure ${D}${sbindir}/power
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/battery_parameters.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/gauge_configure.service ${D}${systemd_unitdir}/system	
}
FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"

SYSTEMD_SERVICE_${PN} = "battery_parameters.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"
