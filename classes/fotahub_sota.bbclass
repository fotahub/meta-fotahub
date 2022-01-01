DISTROOVERRIDES .= "${@bb.utils.contains('DISTRO_FEATURES', 'sota', ':sota', '', d)}"

IMAGE_CLASSES += " image_types_ostree image_types_ota"
IMAGE_INSTALL_append_sota = " ostree os-release ostree-kernel ostree-initramfs \
                              ${@'ostree-devicetrees' if oe.types.boolean('${OSTREE_DEPLOY_DEVICETREE}') else ''}"

IMAGE_FSTYPES += "${@bb.utils.contains('DISTRO_FEATURES', 'sota', 'ostreepush ota-ext4', ' ', d)}"
IMAGE_FSTYPES += "${@bb.utils.contains('BUILD_OSTREE_TARBALL', '1', 'ostree.tar.bz2', ' ', d)}"
IMAGE_FSTYPES += "${@bb.utils.contains('BUILD_OTA_TARBALL', '1', 'ota.tar.xz', ' ', d)}"

PACKAGECONFIG_append_pn-curl = " ssl"
PACKAGECONFIG_remove_pn-curl = "gnutls"

EXTRA_IMAGEDEPENDS_append_sota = " parted-native mtools-native dosfstools-native"

INITRAMFS_FSTYPES ?= "${@oe.utils.ifelse(d.getVar('OSTREE_BOOTLOADER') == 'u-boot', 'cpio.gz.u-boot', 'cpio.gz')}"

# Please redefine OSTREE_REPO in order to have a persistent OSTree repo
OSTREE_REPO ?= "${DEPLOY_DIR_IMAGE}/ostree_repo"
OSTREE_BRANCHNAME ?= "fotahub-os-${MACHINE}"
OSTREE_OSNAME ?= "os"
OSTREE_BOOTLOADER ??= 'u-boot'
OSTREE_BOOT_PARTITION ??= "/boot"
OSTREE_KERNEL ??= "${KERNEL_IMAGETYPE}"
OSTREE_DEPLOY_DEVICETREE ??= "0"
OSTREE_DEVICETREE ??= "${KERNEL_DEVICETREE}"

INITRAMFS_IMAGE ?= "initramfs-ostree-image"

SOTA_MACHINE ??= "${MACHINE}"
SOTA_MACHINE_rpi ?= "raspberrypi"

IMAGE_FSTYPES_remove_sota_rpi = "tar.bz2 ext3"

SOTA_OVERRIDES_BLACKLIST = "ostree ota"
SOTA_REQUIRED_VARIABLES = "OSTREE_REPO OSTREE_BRANCHNAME OSTREE_OSNAME OSTREE_BOOTLOADER OSTREE_BOOT_PARTITION"

inherit sota_sanity sota_${SOTA_MACHINE}

IMAGE_BOOT_FILES_append_sota = " boot.scr uEnv.txt"
