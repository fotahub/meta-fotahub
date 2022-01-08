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
    python3-pydbus \
    python3-pygobject \
    python3-stringcase \
"

SRCREV = "5b7c5c4a7ef22b732070aacd7b9c6ff209b2649f"
SRC_URI += " \
    git://github.com/fotahub/fotahub-device-sdk-yocto.git;branch=main \
    file://fotahubd.service.in \
"

# Redefine unpacked recipe source code location (S) according to the Git fetcher's default checkout location (destsuffix)
# (see https://docs.yoctoproject.org/bitbake/bitbake-user-manual/bitbake-user-manual-fetching.html#git-fetcher-git for details)
S = "${WORKDIR}/git"

FILES_${PN} += " \
    ${sysconfdir}/fotahub.conf \
    ${systemd_system_unitdir}/fotahubd.service \
"

SYSTEMD_SERVICE_${PN} = "fotahubd.service"

inherit systemd setuptools3

do_install_append() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${S}/fotahub.conf.sample ${D}${sysconfdir}/fotahub.conf
    sed -i "s@\(OSTreeGPGVerify\s*=\).\+@\1 ${OSTREE_GPG_VERIFY}@" ${D}${sysconfdir}/fotahub.conf
    sed -i "s@\(OSDistroName\s*=\).\+@\1 ${DISTRO}-${MACHINE}@" ${D}${sysconfdir}/fotahub.conf
    sed -i "s@\(OSRebootOptions\s*=\).\+@\1 ${OS_UPDATE_REBOOT_OPTIONS}@" ${D}${sysconfdir}/fotahub.conf
    sed -i "s@\(OSUpdateVerificationCommand\s*=\).\+@\1 ${OS_UPDATE_VERIFICAITON_COMMAND}@" ${D}${sysconfdir}/fotahub.conf
    sed -i "s@\(OSUpdateSelfTestCommand\s*=\).\+@\1 ${OS_UPDATE_SELF_TEST_COMMAND}@" ${D}${sysconfdir}/fotahub.conf
    sed -i "s@\(AppOSTreeHome\s*=\).\+@\1 /${APPS_DIR}/ostree_repo@" ${D}${sysconfdir}/fotahub.conf

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/fotahubd.service.in ${D}${systemd_system_unitdir}/fotahubd.service
    sed -i "s@{{config}}@${sysconfdir}/fotahub.conf@" ${D}${systemd_system_unitdir}/fotahubd.service
}
