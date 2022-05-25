# Prevent /etc/resolv.conf from being symlinked to /etc/resolv-conf.connman
ALTERNATIVE_${PN} = ""

do_install_append() {

    # Disable ConnMan's DNS proxy intercepting all locally issued DNS resolution requests - it doesn't work
    # for Wi-Fi network interfaces out of the box (i.e, all `ping google.com` requests fail when being  
    # connected (only) through Wi-Fi), and it's not clear how to configure ConnMan's DNS proxy to make it work
    # appropriately (see https://manpages.ubuntu.com/manpages/focal/man8/connman.8.html for details)
    sed -e 's@\(connmand -n\)@\1 -r@g' -i ${D}${systemd_system_unitdir}/connman.service

    # Configure an external standard DNS server instead 
    cat >> ${D}${sysconfdir}/resolv.conf <<EOF
nameserver 8.8.8.8
EOF
}
