DESCRIPTION = "Chip set temperature monitoring application (shell script)"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

IMAGE_INSTALL = " \
    busybox \
    curl \
"

# Container entrypoint
CONTAINER_ENTRYPOINT= "${THISDIR}/files/entrypoint.sh"

# runc configuration
RUNC_CONFIG = "${THISDIR}/files/temperature-monitor-config.json"

# Set AUTOLAUNCH to 1 if application should be launched automatically
AUTOLAUNCH = "1"

inherit package_app_image
inherit push_app_image