FILES_${PN} += " \
    ${ROOT_HOME}/.Xauthority \
"

do_install() {
    install -d ${D}${ROOT_HOME}
    touch ${D}${ROOT_HOME}/.Xauthority
}