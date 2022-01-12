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
OSTREE_OSNAME ?= "fotahub"
OSTREE_BOOTLOADER ??= 'u-boot'
OSTREE_BOOT_PARTITION ??= "/boot"
OSTREE_KERNEL ??= "${KERNEL_IMAGETYPE}"
OSTREE_DEPLOY_DEVICETREE ??= "0"
OSTREE_DEVICETREE ??= "${KERNEL_DEVICETREE}"

INITRAMFS_IMAGE ?= "initramfs-ostree-image"

SOTA_MACHINE ??= "${MACHINE}"
SOTA_MACHINE_rpi ?= "raspberrypi"
SOTA_MACHINE_porter ?= "porter"
SOTA_MACHINE_m3ulcb = "m3ulcb"
SOTA_MACHINE_intel-corei7-64 ?= "minnowboard"
SOTA_MACHINE_qemux86-64 ?= "qemux86-64"
SOTA_MACHINE_am335x-evm ?= "am335x-evm-wifi"
SOTA_MACHINE_freedom-u540 ?= "freedom-u540"

SOTA_MACHINE_OVERRIDES ??= "0"
SOTA_MACHINE_OVERRIDES_rpi ?= "1"

SOTA_OVERRIDES_BLACKLIST = "ostree ota"
SOTA_REQUIRED_VARIABLES = "OSTREE_REPO OSTREE_BRANCHNAME OSTREE_OSNAME OSTREE_BOOTLOADER OSTREE_BOOT_PARTITION"

inherit sota_sanity sota_${SOTA_MACHINE}${@'_overrides' if oe.types.boolean('${SOTA_MACHINE_OVERRIDES}') else ''}
