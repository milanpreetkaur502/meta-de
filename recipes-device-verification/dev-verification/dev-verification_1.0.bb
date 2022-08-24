SUMMARY = "Device Verification Application"
DESCRIPTION = "Device Verification Application"
LICENSE = "CLOSED"

SRC_URI = "file://devdetect.sh \
	   file://devdetect.service \
           "
inherit systemd

S = "${WORKDIR}"

do_compile(){
}


do_install(){
	install -d ${D}${sbindir}/dev-verification
	install -m 777 ${S}/devdetect.sh ${D}${sbindir}/dev-verification
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/devdetect.service ${D}${systemd_unitdir}/system	
}

FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"

SYSTEMD_SERVICE_${PN} = "devdetect.service"


