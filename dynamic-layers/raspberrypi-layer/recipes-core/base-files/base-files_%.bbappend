FILESEXTRAPATHS_prepend_fotahub-os := "${THISDIR}/${MACHINE}:"

do_install_append_fotahub-os() {
    install -d ${D}/${APP_DIRECTORY}

    sed -e 's@{{apps}}@${APP_DIRECTORY}@g' -i ${D}/${sysconfdir}/fstab
}
