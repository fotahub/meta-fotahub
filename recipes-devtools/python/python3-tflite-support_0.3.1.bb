SUMMARY = "tflite-support version ${PV}"
HOMEPAGE = "https://github.com/tensorflow/tflite-support"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit python3-dir

RDEPENDS_${PN} += " \
    ${PYTHON_PN}-absl \
    ${PYTHON_PN}-flatbuffers \
    ${PYTHON_PN}-numpy \
    ${PYTHON_PN}-pybind11 \
"

PYTHON_BV = "${@'${PYTHON_BASEVERSION}'.replace('.', '')}"

# Python Package Index (PyPI) package paths for Python 3.8 used by Dunfell Yocto release 
# (see https://pypi.org/project/tflite-support/#files for details) 
TFLITE_SUPPORT_PACKAGE_PATH = "dc/9d/cc14960e1460e6ab90a800c051c3e26fc56b1fa3f8f54f1311dc973b4f22"
TFLITE_SUPPORT_PACKAGE_PATH:raspberrypi3 = "1f/4f/c632acaa937de6c07705d6f864a7f1ad6e87b52bf2574f8c724d52863b45"
TFLITE_SUPPORT_PACKAGE_PATH:raspberrypi4 = "1f/4f/c632acaa937de6c07705d6f864a7f1ad6e87b52bf2574f8c724d52863b45"
TFLITE_SUPPORT_PACKAGE_PATH:raspberrypi3-64 = "21/e9/2ff09e78e1745d2e9fec1daa8c3143dc8e1fd46596f581a62097b1cccb13"
TFLITE_SUPPORT_PACKAGE_PATH:raspberrypi4-64 = "21/e9/2ff09e78e1745d2e9fec1daa8c3143dc8e1fd46596f581a62097b1cccb13"

TFLITE_SUPPORT_PLATFORM_NAME = "manylinux_2_12_x86_64.manylinux2010_x86_64"
TFLITE_SUPPORT_PLATFORM_NAME:raspberrypi3 = "manylinux2014_armv7l"
TFLITE_SUPPORT_PLATFORM_NAME:raspberrypi4 = "manylinux2014_armv7l"
TFLITE_SUPPORT_PLATFORM_NAME:raspberrypi3-64 = "manylinux2014_aarch64"
TFLITE_SUPPORT_PLATFORM_NAME:raspberrypi4-64 = "manylinux2014_aarch64"

TFLITE_SUPPORT_WHEEL_BASENAME = "tflite_support-${PV}-cp${PYTHON_BV}-cp${PYTHON_BV}-${TFLITE_SUPPORT_PLATFORM_NAME}"

TFLITE_SUPPORT_WHEEL_MD5SUM = "e1527aae3eb7e072d29934d3a9b4d3dc"
TFLITE_SUPPORT_WHEEL_SHA256SUM = "35f573de567809f9c090f71047ff9cc7812e86ee5dccfecf136415c7f7d89d49"
TFLITE_SUPPORT_WHEEL_MD5SUM:raspberrypi3 = "29afb5bcc934078c5e3d425803f79234"
TFLITE_SUPPORT_WHEEL_SHA256SUM:raspberrypi3 = "58fe12c87374d9437123bc629f4be0334ad85467cded33819c7af9b7488c92d6"
TFLITE_SUPPORT_WHEEL_MD5SUM:raspberrypi4 = "29afb5bcc934078c5e3d425803f79234"
TFLITE_SUPPORT_WHEEL_SHA256SUM:raspberrypi4 = "58fe12c87374d9437123bc629f4be0334ad85467cded33819c7af9b7488c92d6"
TFLITE_SUPPORT_WHEEL_MD5SUM:raspberrypi3-64 = "353deb2bf1eb254b0fbdc537d0b9f438"
TFLITE_SUPPORT_WHEEL_SHA256SUM:raspberrypi3-64 = "975a1add60e16072b5cd9c022d4712a02ffa0ecc7000c510a98af5e3de338c63"
TFLITE_SUPPORT_WHEEL_MD5SUM:raspberrypi4-64 = "353deb2bf1eb254b0fbdc537d0b9f438"
TFLITE_SUPPORT_WHEEL_SHA256SUM:raspberrypi4-64 = "975a1add60e16072b5cd9c022d4712a02ffa0ecc7000c510a98af5e3de338c63"

SRC_URI = "https://files.pythonhosted.org/packages/${TFLITE_SUPPORT_PACKAGE_PATH}/${TFLITE_SUPPORT_WHEEL_BASENAME}.whl;downloadfilename=${TFLITE_SUPPORT_WHEEL_BASENAME}.zip;subdir=${BP}"
SRC_URI[md5sum] = "${TFLITE_SUPPORT_WHEEL_MD5SUM}"
SRC_URI[sha256sum] = "${TFLITE_SUPPORT_WHEEL_SHA256SUM}"

do_unpack[depends] += "unzip-native:do_populate_sysroot"

FILES_${PN} += "\
    ${PYTHON_SITEPACKAGES_DIR}/* \
"

do_install() {
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    find . -type f -exec install -Dm 755 {} ${D}${PYTHON_SITEPACKAGES_DIR}/{} \;
}
