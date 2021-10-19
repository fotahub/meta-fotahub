IMAGE_FSTYPES = "ext4"

PREINSTALLED_APPS_append ?= "hello-world-app"
IMAGE_ROOTFS_EXTRA_SPACE ?= "314572"

inherit package_preinstalled_apps_repo_image
