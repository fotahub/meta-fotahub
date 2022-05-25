do_install_append_fotahub-os() {
    if [ -n "${PREINSTALLED_APPS}" ]; then
        install -d ${D}/${APPS_DIR}
        cat >> ${D}${sysconfdir}/fstab <<EOF

/dev/mmcblk0p3	/${APPS_DIR}	ext4	defaults	0	0

EOF
    fi
}
