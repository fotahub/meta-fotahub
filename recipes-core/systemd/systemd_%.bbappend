do_install_append() {
    sed -e 's@\(ExecStart=.\+\)@\1 --any@g' -i ${D}/${systemd_system_unitdir}/systemd-networkd-wait-online.service
    
    install -d ${D}/${sysconfdir}/systemd/system/sysinit.target.wants
    ln -s -r "${D}/${systemd_system_unitdir}/systemd-time-wait-sync.service" "${D}/${sysconfdir}/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service"
}