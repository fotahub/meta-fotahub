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

HOMEPAGE = "https://github.com/fotahub/fotahub-device-sdk-yocto"
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
    python3-pkg-resources \
    python3-pydbus \
    python3-pygobject \
    python3-stringcase \
"

SRCREV = "91627285cb1e7bf8443c4ea77ff3e5d7017cd642"
SRC_URI += " \
    git://github.com/fotahub/fotahub-device-sdk-yocto.git;branch=main \
    file://fotahubd.service.in \
"

# Redefine unpacked recipe source code location (S) according to the Git fetcher's default checkout location (destsuffix)
# (see https://docs.yoctoproject.org/bitbake/bitbake-user-manual/bitbake-user-manual-fetching.html#git-fetcher-git for details)
S = "${WORKDIR}/git"

FOTAHUB_CONFIG_PATH ?= "/etc/fotahub/fotahub.config"

FILES_${PN} += " \
    ${base_prefix}${FOTAHUB_CONFIG_PATH} \
    ${systemd_system_unitdir}/fotahubd.service \
"

SYSTEMD_SERVICE_${PN} = "fotahubd.service"

inherit systemd setuptools3

do_install_append() {
    install -d ${D}${base_prefix}$(dirname ${FOTAHUB_CONFIG_PATH})
    install -m 0644 ${S}/fotahub.config.sample ${D}${base_prefix}${FOTAHUB_CONFIG_PATH}
    sed -i "s@\(OSTreeGPGVerify\s*=\).\+@\1 ${OSTREE_GPG_VERIFY}@" ${D}${base_prefix}${FOTAHUB_CONFIG_PATH}
    sed -i "s@\(OSDistroName\s*=\).\+@\1 ${DISTRO}-${MACHINE}@" ${D}${base_prefix}${FOTAHUB_CONFIG_PATH}
    sed -i "s@\(OSUpdateVerificationCommand\s*=\).\+@\1 ${OS_UPDATE_VERIFICAITON_COMMAND}@" ${D}${base_prefix}${FOTAHUB_CONFIG_PATH}
    sed -i "s@\(OSUpdateSelfTestCommand\s*=\).\+@\1 ${OS_UPDATE_SELF_TEST_COMMAND}@" ${D}${base_prefix}${FOTAHUB_CONFIG_PATH}
    sed -i "s@\(AppOSTreeHome\s*=\).\+@\1 /${APPS_DIR}/ostree_repo@" ${D}${base_prefix}${FOTAHUB_CONFIG_PATH}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/fotahubd.service.in ${D}${systemd_system_unitdir}/fotahubd.service
    sed -i "s@{{config}}@${FOTAHUB_CONFIG_PATH}@" ${D}${systemd_system_unitdir}/fotahubd.service
}
