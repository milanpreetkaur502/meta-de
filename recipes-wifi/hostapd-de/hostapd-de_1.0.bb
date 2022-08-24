SUMMARY = "Hostapd hotspot for digital entomologist"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN} = "hostapd"

S = "${WORKDIR}"

SRC_URI = " \
    file://enable-ap.service \
    file://hostapd-de.service \
    file://hostapd-de.network \
    file://hostapd-de-ap.conf \
    file://wifi.sh \
    file://fw_loader_arm64 \
    file://helper_uart_3000000.bin \
    file://pcie8997_wlan_v4.bin \
    file://pcieuart8997_combo_v4.bin \
    file://uart8997_bt_v4.bin \
    file://wifi_mod_para.conf \
    file://WlanCalData_ext_DB-W8997QFN-DB3A_V3.0_Rev-A.conf \
    "

inherit systemd

SYSTEMD_SERVICE_${PN} = "hostapd-de.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

do_install() {
    install -d ${D}${base_libdir}/firmware/nxp/
    install -d ${D}${systemd_unitdir}/system/ ${D}${systemd_unitdir}/network/ ${D}${sysconfdir}/ 
    install -d ${D}${sbindir}/ ${D}${sbindir}/hostapd-de/
    install -m 0644 fw_loader_arm64 ${D}${base_libdir}/firmware/nxp/
    install -m 0644 helper_uart_3000000.bin ${D}${base_libdir}/firmware/nxp/
    install -m 0644 pcie8997_wlan_v4.bin ${D}${base_libdir}/firmware/nxp/
    install -m 0644 pcieuart8997_combo_v4.bin ${D}${base_libdir}/firmware/nxp/
    install -m 0644 uart8997_bt_v4.bin ${D}${base_libdir}/firmware/nxp/
    install -m 0644 wifi_mod_para.conf ${D}${base_libdir}/firmware/nxp/
    install -m 0644 WlanCalData_ext_DB-W8997QFN-DB3A_V3.0_Rev-A.conf ${D}${base_libdir}/firmware/nxp/   
    install -m 0644 enable-ap.service ${D}${systemd_unitdir}/system/
    install -m 0644 hostapd-de.network ${D}${systemd_unitdir}/network/
    install -m 0644 hostapd-de.service ${D}${systemd_unitdir}/system/
    install -m 0644 hostapd-de-ap.conf ${D}${sysconfdir}/
    install -m 0777 ${S}/wifi.sh ${D}${sbindir}/hostapd-de/
    sed -i -e 's,@SBINDIR@,${sbindir},g' -e 's,@SYSCONFDIR@,${sysconfdir},g' ${D}${systemd_unitdir}/system/hostapd-de.service
}

FILES_${PN} += " \
    ${base_libdir}/firmware/nxp/* \
    ${systemd_unitdir}/system/* \
    ${systemd_unitdir}/network/hostapd-de.network \
    ${sysconfdir}/hostapd-de-ap.conf \
    ${sbindir}/hostapd-de/* \
"

RDEPENDS_${PN} += "bash"

