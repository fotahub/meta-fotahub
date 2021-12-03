FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

SRC_URI_append = " \
    file://wired.network \
"

FILES_${PN} += " \
    ${nonarch_base_libdir}/systemd/network \
"

PACKAGECONFIG_append = " networkd"

do_install_append() {
    # The network files need to be located in /usr/lib/systemd, but not in ${systemd_unitdir}
    install -d ${D}${prefix}/lib/systemd/network/
    install -d ${D}/etc/systemd/network/
    install -m 0644 ${WORKDIR}/wired.network ${D}/etc/systemd/network/

    rm ${D}${sysconfdir}/systemd/system/getty.target.wants/getty@tty1.service
}
