SUMMARY = "System Information SD Application"
DESCRIPTION = "System Information SD Application"
LICENSE = "CLOSED"

SRC_URI = "file://systeminfo-sd.sh \
	   file://systeminfo-sd.service \
           "
inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install(){
	install -d ${D}${sbindir}/systeminfo-sd
	install -m 777 ${S}/systeminfo-sd.sh ${D}${sbindir}/systeminfo-sd
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/systeminfo-sd.service ${D}${systemd_unitdir}/system	
}

FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"

SYSTEMD_SERVICE_${PN} = "systeminfo-sd.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

