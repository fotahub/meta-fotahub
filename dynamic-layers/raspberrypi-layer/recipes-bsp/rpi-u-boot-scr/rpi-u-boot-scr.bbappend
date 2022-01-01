FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://uEnv.txt.in \
"

do_compile_append() {
    sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/' \
        -e 's/@@KERNEL_BOOTCMD@@/${KERNEL_BOOTCMD}/' \
        "${WORKDIR}/uEnv.txt.in" > "${WORKDIR}/uEnv.txt"
}

do_deploy_append() {
    install -m 0644 ${WORKDIR}/uEnv.txt ${DEPLOYDIR}
}