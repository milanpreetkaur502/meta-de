SUMMARY = "GPS application"
DESCRIPTION = "get gps data"
LICENSE = "CLOSED"


SRC_URI = "file://gps.sh \
	   file://gps.service \
           "

inherit allarch systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){        
	install -d ${D}${sbindir}/gps
	install -m 777 ${S}/gps.sh ${D}/${sbindir}/gps
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/gps.service ${D}${systemd_unitdir}/system

}

SYSTEMD_SERVICE_${PN} = "gps.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"
