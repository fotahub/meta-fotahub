DESCRIPTION = "OCI Container including busybox and a sh script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

IMAGE_INSTALL = " \
    busybox \
"

# Container entrypoint
CONTAINER_ENTRYPOINT= "${THISDIR}/files/entrypoint.sh"

# Runc configuration
RUNC_CONFIG = "${THISDIR}/files/hello-world-config.json"

# systemd configuration
SYSTEMD_CONFIG = "${THISDIR}/files/hello-world.service"

# Set AUTOSTART to 1 if the application should be started automatically by systemd
AUTOSTART = "0"

# Set AUTOREMOVE to 1 if the application should be removed automatically from the targets for the next update of the application
AUTOREMOVE = "0"

# Set GUI to 1 if the application requires support for displaying a GUI (X11 and Wayland)
GUI = "0"

inherit package_app_image
inherit push_app_image