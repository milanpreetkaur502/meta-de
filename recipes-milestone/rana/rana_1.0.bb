SUMMARY = "Rana Application"
DESCRIPTION = "Rana motion detection application"
LICENSE = "CLOSED"


SRC_URI = "file://rana.sh \
           file://rana.service \
           file://ranacore \
           file://ranacore.conf \
           "

inherit systemd

S = "${WORKDIR}"

do_compile(){
}

do_install_append(){
        
	install -d ${D}${sbindir}/rana
	install -m 777 ${S}/rana.sh ${D}${sbindir}/rana
	install -m 777 ${S}/ranacore ${D}${sbindir}/rana
	install -m 777 ${S}/ranacore.conf ${D}${sbindir}/rana
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/rana.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE_${PN} = "rana.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"

INSANE_SKIP_${PN} += "already-stripped"
