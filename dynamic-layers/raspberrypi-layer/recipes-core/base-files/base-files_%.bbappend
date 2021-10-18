FILESEXTRAPATHS_prepend_fotahub-os := "${THISDIR}/${MACHINE}:"

do_install_append_fotahub-os() {
    install -d ${D}/${APPS_DIR}

    sed -e 's@{{apps}}@${APPS_DIR}@g' -i ${D}/${sysconfdir}/fstab
}
