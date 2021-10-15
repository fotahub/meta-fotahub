#
#  Copyright (C) 2021 FotaHub Inc. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License"); you may
#  not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#  This file is part of the FotaHub(R) Device SDK program (https://fotahub.com)
#

DESCRIPTION = "FotaHub Client daemon"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS_${PN} += " \
    u-boot-fw-utils \
    socat \
    dbus \
    systemd \
    ostree \
    python3 \
    python3-pydbus \
    python3-pygobject \
    python3-stringcase \
"

SRCREV = "4410213c48be2237ba6e4297f31620d2431799d5"
SRC_URI += " \
    git://github.com/fotahub/fotahub-device-sdk-yocto.git;branch=main \
    file://fotahubd.service \
"

# Redefine unpacked recipe source code location (S) according to the Git fetcher's default checkout location (destsuffix)
# (see https://docs.yoctoproject.org/bitbake/bitbake-user-manual/bitbake-user-manual-fetching.html#git-fetcher-git for details)
S = "${WORKDIR}/git"

OSTREE_CONFIG_PATH ?= "/etc/fotahub/fotahub.config"

FILES_${PN} += " \
    ${base_prefix}${OSTREE_CONFIG_PATH} \
    ${systemd_system_unitdir}/fotahubd.service \
"

SYSTEMD_SERVICE_${PN} = "fotahubd.service"

inherit systemd setuptools3

do_install_append() {
    install -d ${D}${base_prefix}$(dirname ${OSTREE_CONFIG_PATH})
    sed "s#\(gpg.verify\s*=\s*\)[a-zA-Z]\+#\1`if [ -n "${OSTREE_GPG_VERIFY}" ]; then echo "true"; else echo "false"; fi`#" ${S}/fotahub.config.sample > ${D}${base_prefix}${OSTREE_CONFIG_PATH}
    chmod 0644 ${D}${base_prefix}${OSTREE_CONFIG_PATH}

    install -d ${D}${systemd_system_unitdir}
    sed "s#{{config}}#${OSTREE_CONFIG_PATH}#" ${WORKDIR}/fotahubd.service > ${D}${systemd_system_unitdir}/fotahubd.service
    chmod 0644 ${D}${systemd_system_unitdir}/fotahubd.service
}
