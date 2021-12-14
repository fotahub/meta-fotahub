SUMMARY = "Terminal-based tool for making large letters out of ordinary text"
HOMEPAGE = "http://www.figlet.org"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1688bcd97b27704f1afcac7336409857"

SRC_URI = "git://github.com/cmatsuoka/figlet.git;nobranch=1;tag=${PV};destsuffix=git"

# Redefine unpacked recipe source code location (S) according to the Git fetcher's default checkout location (destsuffix)
# (see https://docs.yoctoproject.org/bitbake/bitbake-user-manual/bitbake-user-manual-fetching.html#git-fetcher-git for details)
S = "${WORKDIR}/git"

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
    install -m 0755 ${S}/figlet ${D}${bindir}
    install -m 0755 ${S}/chkfont ${D}${bindir}
    install -m 0755 ${S}/figlist ${D}${bindir}
    install -m 0755 ${S}/showfigfonts ${D}${bindir}
    install -m 0644 ${S}/fonts/*.flf ${D}${DEFAULTFONTDIR}
}
