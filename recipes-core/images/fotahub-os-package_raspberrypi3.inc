WIC_CREATE_EXTRA_ARGS_append = "--no-fstab-update "

DEPENDS += "bcm2835-bootfiles"

IMAGE_INSTALL_append = " \
    userland \
"
