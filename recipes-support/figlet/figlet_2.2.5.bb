SUMMARY = "Terminal-based tool for making large letters out of ordinary text"
HOMEPAGE = "http://www.figlet.org"
LICENSE = "Custom"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1688bcd97b27704f1afcac7336409857"
NO_GENERIC_LICENSE[Custom] = "LICENSE"

SRC_URI = "ftp://ftp.figlet.org/pub/figlet/program/unix/${PN}-${PV}.tar.gz"
SRC_URI[md5sum] = "d88cb33a14f1469fff975d021ae2858e"
SRC_URI[sha256sum] = "bf88c40fd0f077dab2712f54f8d39ac952e4e9f2e1882f1195be9e5e4257417d"

S = "${WORKDIR}/${PN}-${PV}"


DEFAULTFONTDIR = "${STAGING_DIR_TARGET}/share/figlet"
DEFAULTFONTFILE = "standard"

EXTRA_OEMAKE = "'CC=${CC}' 'CFLAGS=${CFLAGS}' 'LD=${CC}' 'LDFLAGS=${TARGET_LDFLAGS}'"

do_compile() {
    oe_runmake DEFAULTFONTDIR="${DEFAULTFONTDIR}" DEFAULTFONTFILE="${DEFAULTFONTFILE}"
}

FILES_${PN} += " \
    ${DEFAULTFONTDIR} \
"

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${DEFAULTFONTDIR}
    install -m 0755 figlet ${D}${bindir}
    install -m 0755 chkfont ${D}${bindir}
    install -m 0755 figlist ${D}${bindir}
    install -m 0755 showfigfonts ${D}${bindir}
    install -m 0644 ${S}/fonts/*.flf ${D}${DEFAULTFONTDIR}
}

