# Add U-Boot scripts to boot partition
IMAGE_BOOT_FILES_append_sota_rpi = " boot.scr uEnv.txt "

# Force usage of vc4-kms-v3d instead of vc4-fkms-v3d device tree overlay (VC4 graphics driver for Broadcom’s VideoCore IV GPU) 
# to avoid empty black screen right after boot (see meta-updater/classes/sota_raspberrypi.bbclass for original settings)
KERNEL_DEVICETREE_raspberrypi4_sota = " bcm2711-rpi-4-b.dtb overlays/vc4-kms-v3d.dtbo overlays/uart0-rpi4.dtbo"
SOTA_DT_OVERLAYS_raspberrypi4 = "vc4-kms-v3d.dtbo uart0-rpi4.dtbo"

# Set OStree-managed Kernel args
# (inspired by meta-raspberrypi/recipes-bsp/bootfiles/rpi-cmdline.bb in hardknott,
# see https://www.kernel.org/doc/html/v4.14/admin-guide/kernel-parameters.html for details)
OSTREE_KERNEL_ARGS_DWC_OTG ?= "dwc_otg.lpm_enable=0"
OSTREE_KERNEL_ARGS_ROOTFS ?= "root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait rootdelay=2 ramdisk_size=8192 panic=1"

OSTREE_KERNEL_ARGS_SERIAL ?= "${@oe.utils.conditional("ENABLE_UART", "1", "console=serial0,115200", "", d)}"

OSTREE_KERNEL_ARGS_CMA ?= "${@oe.utils.conditional("RASPBERRYPI_CAMERA_V2", "1", "cma=64M", "", d)}"

OSTREE_KERNEL_ARGS_CMA ?= "${@oe.utils.conditional("RASPBERRYPI_HD_CAMERA", "1", "cma=64M", "", d)}"

OSTREE_KERNEL_ARGS_PITFT ?= "${@bb.utils.contains("MACHINE_FEATURES", "pitft", "fbcon=map:10 fbcon=font:VGA8x8", "", d)}"

# Add the kernel debugger over console kernel command line option if enabled in your local.conf or distro.conf
OSTREE_KERNEL_ARGS_KGDB ?= '${@oe.utils.conditional("ENABLE_KGDB", "1", "kgdboc=serial0,115200", "", d)}'

# Suppress rpi logo on boot if enabled in your local.conf or distro.conf
OSTREE_KERNEL_ARGS_LOGO ?= '${@oe.utils.conditional("DISABLE_RPI_BOOT_LOGO", "1", "logo.nologo", "", d)}'

# You can define OSTREE_KERNEL_ARGS_DEBUG as "debug" in your local.conf or distro.conf to enable kernel debugging
OSTREE_KERNEL_ARGS_DEBUG ?= ""

OSTREE_KERNEL_ARGS_sota = " \
    ${OSTREE_KERNEL_ARGS_DWC_OTG} \
    ${OSTREE_KERNEL_ARGS_SERIAL} \
    ${OSTREE_KERNEL_ARGS_ROOTFS} \
    ${OSTREE_KERNEL_ARGS_CMA} \
    ${OSTREE_KERNEL_ARGS_KGDB} \
    ${OSTREE_KERNEL_ARGS_LOGO} \
    ${OSTREE_KERNEL_ARGS_PITFT} \
    ${OSTREE_KERNEL_ARGS_DEBUG} \
    "

# Suppress unnecessary Raspberry Pi image types 
# (introduced by meta-raspberrypi/conf/machine/include/rpi-base.inc)
IMAGE_FSTYPES_remove_sota_rpi = "tar.bz2 ext3 wic.bz2"

inherit sota_${SOTA_MACHINE}