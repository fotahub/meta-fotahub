IMAGE_FSTYPES = "ext4"

IMAGE_ROOTFS_EXTRA_SPACE ?= "314572"

DEPENDS += "${PREINSTALLED_APPS}"

inherit package_preinstalled_apps_repo_image
