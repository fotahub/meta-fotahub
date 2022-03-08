SUMMARY = "python3-flatbuffers version ${PV}"
HOMEPAGE = "https://github.com/google/flatbuffers"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit pypi setuptools3

RDEPENDS_${PN} += " \
    flatbuffers \
"

SRC_URI[md5sum] = "b9a5b8dfbbb4751788529310118ea6db"
SRC_URI[sha256sum] = "63bb9a722d5e373701913e226135b28a6f6ac200d5cc7b4d919fa38d73b44610"
