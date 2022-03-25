FILES_${PN} += " \
    ${ROOT_HOME}/.Xauthority \
"

do_install_append() {
    install -d ${D}${ROOT_HOME}
    touch ${D}${ROOT_HOME}/.Xauthority
}