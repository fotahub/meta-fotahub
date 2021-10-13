OVERRIDES .= "${@bb.utils.contains('DISTRO_FEATURES', 'sota', ':sota', '', d)}"

HOSTTOOLS_NONFATAL += "java"

IMAGE_INSTALL_append_sota = " ostree os-release"
IMAGE_CLASSES += " image_types_ostree"
IMAGE_FSTYPES += "${@bb.utils.contains('DISTRO_FEATURES', 'sota', 'ostreepush wic', ' ', d)}"

PACKAGECONFIG_append_pn-curl = " ssl"
PACKAGECONFIG_remove_pn-curl = "gnutls"

EXTRA_IMAGEDEPENDS_append_sota = " parted-native mtools-native dosfstools-native"

OSTREE_INITRAMFS_FSTYPES ??= "${@oe.utils.ifelse(d.getVar('OSTREE_BOOTLOADER', True) == 'u-boot', 'ext4.gz.u-boot', 'ext4.gz')}"

OSTREE_REPO ?= "${DEPLOY_DIR_IMAGE}/ostree_repo"
OSTREE_BRANCHNAME ?= "fotahub-os-${MACHINE}"
OSTREE_OSNAME ?= "os"
OSTREE_BOOTLOADER ??= 'u-boot'
OSTREE_BOOT_PARTITION ??= "/boot"

OSTREE_INITRAMFS_IMAGE ?= "initramfs-ostree-image"

inherit fullmetalupdate_sota_${MACHINE}
