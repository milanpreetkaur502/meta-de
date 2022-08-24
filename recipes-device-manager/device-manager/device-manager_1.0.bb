SUMMARY = "Digital Entomologist Device Manager"
DESCRIPTION = "Device manager flask HTTP web server"
HOMEPAGE = "https://github.com/milanpreetkaur502/device-manager-ento.git"
LICENSE = "CLOSED"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/milanpreetkaur502/device-manager-ento.git;protocol=https;user=milanpreetkaur502+deploy-token-1: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;branch=main"

inherit systemd

S = "${WORKDIR}/git"

do_compile(){
}

do_install_append(){
        
	install -d ${D}${sbindir}/device-manager
	cp -r ${S}/* ${D}/${sbindir}/device-manager
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${S}/devicemgr.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE_${PN} = "devicemgr.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

FILES_${PN} += " \
    ${systemd_unitdir}/system/* \
"
