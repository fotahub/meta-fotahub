DESCRIPTION = "Service for automatically unblocking RF Kill soft blocked wireless interfaces"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS_${PN} += "bash busybox"

SRC_URI += " \
    file://rfkill-unblock.service \
    file://rfkill-unblock.sh \
"

SYSTEMD_SERVICE_${PN} = "rfkill-unblock.service"

inherit systemd

do_install () {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/rfkill-unblock.service ${D}${systemd_system_unitdir}/rfkill-unblock.service

    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/rfkill-unblock.sh ${D}${bindir}/rfkill-unblock.sh
}

FILES_${PN} = " \
                ${systemd_system_unitdir}/rfkill-unblock.service \
                ${bindir}/rfkill-unblock.sh \
              "
