DESCRIPTION = "A minimal image supporting over-the-air OS and application updates using OSTree and OCI containers"

EXTRA_IMAGEDEPENDS += "virtual/bootloader"

IMAGE_OVERHEAD_FACTOR = "2"

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    virtual/runc \
    python3-fotahubclient \
"

IMAGE_INSTALL_append = " ${@bb.utils.contains('DISTRO_FEATURES','x11','xauth','',d)}"

IMAGE_INSTALL_append_rpi = " \
    kernel-modules \
    rfkill-unblock \
"

IMAGE_FSTYPES += "wic"
WKS_FILES ?= "fotahub-${SOTA_MACHINE}.wks.in"
WIC_CREATE_EXTRA_ARGS_append = " --no-fstab-update"

inherit core-image
inherit push_os_image
