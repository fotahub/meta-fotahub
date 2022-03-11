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
}