FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_rpi = " \
    file://0001-Add-boot-partition-information.patch \
    file://fw_env.config \
"

# Enable emission of U-Boot debug messages in case of problems when running 'bootm' command and parsing FIT image configurations
SRC_URI_append_rpi = " \
    file://0002-Debug-image-fit.c.patch \
"