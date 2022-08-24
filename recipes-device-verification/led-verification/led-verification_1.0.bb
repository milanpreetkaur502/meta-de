SUMMARY = "LED Verification Application"
DESCRIPTION = "LED Verification Application"
LICENSE = "CLOSED"

SRC_URI = "file://status-leds.sh \
	   file://led.service \
           "
inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install(){
	install -d ${D}${sbindir}/led-verification
	install -m 777 ${S}/status-leds.sh ${D}${sbindir}/led-verification
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/led.service ${D}${systemd_unitdir}/system	
}

FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"

SYSTEMD_SERVICE_${PN} = "led.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

