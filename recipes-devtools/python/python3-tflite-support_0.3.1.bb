SUMMARY = "tflite-support version ${PV}"
HOMEPAGE = "https://github.com/tensorflow/tflite-support"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit python3-dir

RDEPENDS_${PN} += " \
    python3-absl \
    python3-flatbuffers \
    python3-numpy \
    python3-pybind11 \
"

SRC_URI = "https://files.pythonhosted.org/packages/1f/4f/c632acaa937de6c07705d6f864a7f1ad6e87b52bf2574f8c724d52863b45/tflite_support-0.3.1-cp38-cp38-manylinux2014_armv7l.whl;downloadfilename=tflite_support-0.3.1-cp38-cp38-manylinux2014_armv7l.zip;subdir=${BP}"
SRC_URI[md5sum] = "29afb5bcc934078c5e3d425803f79234"
SRC_URI[sha256sum] = "58fe12c87374d9437123bc629f4be0334ad85467cded33819c7af9b7488c92d6"

do_unpack[depends] += "unzip-native:do_populate_sysroot"

FILES_${PN} += "\
    ${PYTHON_SITEPACKAGES_DIR}/* \
"

do_install() {
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    find . -type f -exec install -Dm 755 {} ${D}${PYTHON_SITEPACKAGES_DIR}/{} \;
}
