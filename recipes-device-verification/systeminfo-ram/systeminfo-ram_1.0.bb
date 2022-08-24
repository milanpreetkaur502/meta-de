SUMMARY = "System Information RAM Application"
DESCRIPTION = "System Information RAM Application"
LICENSE = "CLOSED"

SRC_URI = "file://systeminfo-ram.sh \
	   file://systeminfo-ram.service \
           "
inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install(){
	install -d ${D}${sbindir}/systeminfo-ram
	install -m 777 ${S}/systeminfo-ram.sh ${D}${sbindir}/systeminfo-ram
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/systeminfo-ram.service ${D}${systemd_unitdir}/system	
}

FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"

SYSTEMD_SERVICE_${PN} = "systeminfo-ram.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

