# Force usage of vc4-kms-v3d instead of vc4-fkms-v3d device tree overlay (VC4 graphics driver for Broadcom’s VideoCore IV GPU) 
# to avoid empty black screen right after boot (see meta-raspberrypi/conf/machine/raspberrypi3.conf for original settings)
VC4DTBO_raspberrypi3 ?= "vc4-kms-v3d"
VC4DTBO_raspberrypi4 ?= "vc4-kms-v3d"

do_deploy_append() {
    # Waveshare "B" 1280x800 10.1" IPS capacitive touch screen (https://www.waveshare.com/wiki/10.1inch_HDMI_LCD_(B)_(with_case))
    if [ "${WAVESHARE_1280x800_B_2_1}" = "1" ]; then
        echo "# Waveshare \"B\" 1280x800 10.1\" IPS capacitive touch screen" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "max_usb_current=1" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "hdmi_group=2" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "hdmi_mode=87" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "hdmi_cvt 1280 800 60 6 0 0 0" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "hdmi_drive=1" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi

    # WIMAXIT M1160S 1920X1080 11.6" portable monitor (https://wimaxit.com/products/wimaxit-m1160s-portable-monitor)
    if [ "${WIMAXIT_1920x1080_11_6}" = "1" ]; then
        echo "# WIMAXIT M1160S 1920X1080 11.6\" portable monitor" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "max_usb_current=1" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "hdmi_group=2" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "hdmi_mode=87" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "hdmi_cvt 1280 720 60 6 0 0 0" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "hdmi_drive=1" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi
}