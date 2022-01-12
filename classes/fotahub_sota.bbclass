python __anonymous() {
    if bb.utils.contains('DISTRO_FEATURES', 'sota', True, False, d):
        d.appendVarFlag("do_image_wic", "depends", " %s:do_image_otaimg" % d.getVar("IMAGE_BASENAME", True))
}

DISTROOVERRIDES .= "${@bb.utils.contains('DISTRO_FEATURES', 'sota', ':sota', '', d)}"

IMAGE_INSTALL_append_sota = " ostree os-release"
IMAGE_CLASSES += " image_types_ostree image_types_ota"
IMAGE_FSTYPES += "${@bb.utils.contains('DISTRO_FEATURES', 'sota', 'ostreepush otaimg', ' ', d)}"

PACKAGECONFIG_append_pn-curl = " ssl"
PACKAGECONFIG_remove_pn-curl = "gnutls"

EXTRA_IMAGEDEPENDS_append_sota = " parted-native mtools-native dosfstools-native"

OSTREE_INITRAMFS_FSTYPES ??= "${@oe.utils.ifelse(d.getVar('OSTREE_BOOTLOADER', True) == 'u-boot', 'ext4.gz.u-boot', 'ext4.gz')}"

OSTREE_REPO ?= "${DEPLOY_DIR_IMAGE}/ostree_repo"
OSTREE_BRANCHNAME ?= "fotahub-os-${MACHINE}"
OSTREE_OSNAME ?= "fotahub"
OSTREE_BOOTLOADER ??= 'u-boot'
OSTREE_BOOT_PARTITION ??= "/boot"

OSTREE_INITRAMFS_IMAGE ?= "initramfs-ostree-image"

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

inherit sota_sanity sota_${SOTA_MACHINE}${@'_overrides' if oe.types.boolean('${SOTA_MACHINE_OVERRIDES}') else ''}

