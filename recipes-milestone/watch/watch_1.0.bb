SUMMARY = "Watchdog"
DESCRIPTION = "Watchdog"
LICENSE = "CLOSED"

update_sudoers(){
	touch ${IMAGE_ROOTFS}/etc/world
        echo -n 'RuntimeWatchdogSec=180' >> ${IMAGE_ROOTFS}/etc/systemd/system.conf
}

ROOTFS_POSTPROCESS_COMMAND += " update_sudoers;"

