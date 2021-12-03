FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = "u-boot-mkimage-native"

SRC_URI += "file://boot.scr \
            file://uEnv.txt \
"

do_deploy_append() {
    install -d ${DEPLOYDIR}/${PN}

    mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "OSTree-enabled boot script" -d ${WORKDIR}/boot.scr ${DEPLOYDIR}/${PN}/boot.scr.uimg
    install -m 0755 ${WORKDIR}/uEnv.txt ${DEPLOYDIR}/${PN}/uEnv.txt
}
