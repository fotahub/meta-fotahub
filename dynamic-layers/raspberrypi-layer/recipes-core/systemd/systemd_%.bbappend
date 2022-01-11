do_install_append() {
    sed -e 's@\(ExecStart=.\+\)@\1 --any@g' -i ${D}/${systemd_system_unitdir}/systemd-networkd-wait-online.service
}