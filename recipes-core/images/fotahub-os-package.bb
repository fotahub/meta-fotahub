require ${PN}_${MACHINE}.inc

DESCRIPTION = "A minimal image supporting over-the-air OS and application updates using OSTree and OCI containers"

EXTRA_IMAGEDEPENDS += "virtual/bootloader"

IMAGE_FSTYPES += "ext4"
IMAGE_OVERHEAD_FACTOR = "2"

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    mdns \
    libnss-mdns \
    ostree \
    virtual/runc \
    busybox-udhcpc \
    fotahubclient \
"

PACKAGECONFIG_remove-pn-qtbase  = "x11 xcb xkb xkbcommon-evdev "

WKS_FILES ?= "fotahub-${MACHINE}.wks.in"

inherit core-image
inherit push_os_image