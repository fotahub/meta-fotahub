DESCRIPTION = "A minimal image supporting over-the-air OS and application updates using OSTree and OCI containers"

EXTRA_IMAGEDEPENDS += "virtual/bootloader"

IMAGE_OVERHEAD_FACTOR = "2"

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    python3-fotahubclient \
    ${@bb.utils.contains('DISTRO_FEATURES','x11','xauth','',d)} \
    ${@'virtual/runc' if d.getVar('PREINSTALLED_APPS') else ''} \
"

IMAGE_INSTALL_append_rpi = " \
    kernel-modules \
    ${@bb.utils.contains('RPI_WIFI_ENABLE', '1', 'hostapd rfkill-unblock', '', d)} \
"

IMAGE_FSTYPES += "wic"
WKS_FILES ?= "${@ 'sdimage-sota-apps-${SOTA_MACHINE}.wks.in' if d.getVar('PREINSTALLED_APPS') else 'sdimage-sota.wks'}"
WIC_CREATE_EXTRA_ARGS_append = " --no-fstab-update"

inherit core-image
inherit push_os_image
