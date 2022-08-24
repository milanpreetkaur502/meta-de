SUMMARY = "Network LED application"
DESCRIPTION = "Monitor network status"
LICENSE = "CLOSED"


SRC_URI = "file://networkled.sh \
	   file://networkled.service \
	   file://network_led.conf \
           "

inherit allarch systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){
        
	install -d ${D}${sbindir}/networkled
	install -d ${D}${sysconfdir}/entomologist
	install -m 777 ${S}/network_led.conf ${D}/${sysconfdir}/entomologist
	install -m 777 ${S}/networkled.sh ${D}/${sbindir}/networkled
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/networkled.service ${D}${systemd_unitdir}/system
        
}

SYSTEMD_SERVICE_${PN} = "networkled.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"
