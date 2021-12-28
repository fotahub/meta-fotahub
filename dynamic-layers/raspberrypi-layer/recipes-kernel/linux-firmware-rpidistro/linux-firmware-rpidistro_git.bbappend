SRC_URI = "git://github.com/RPi-Distro/firmware-nonfree;branch=buster;protocol=https"

SRCREV = "98e815735e2c805d65994ccc608f399595b74438"
PV = "20190114-1+rpt8"

do_install_append() {
    # add compat links. Fixes errors like
    # brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt failed with error -2
    ln -s brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt
    ln -s brcmfmac43455-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt
    ln -s brcmfmac43430-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt
}
