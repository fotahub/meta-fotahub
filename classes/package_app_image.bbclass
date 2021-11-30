# Class to create tarball for an application
#
# The tarball will have the following architecture:
# - ./config.json
# - ./rootfs/<rest of rootfs>

ROOTFS_BOOTSTRAP_INSTALL = ""
KERNELDEPMODDEPEND = ""
IMAGE_LINGUAS = ""

ROOTFS_POSTPROCESS_COMMAND += "oci_tarball_creation_hook; "

APP_IMAGE_ROOTFS = "${WORKDIR}/rootfs-runc"

#
# A hook function to shrink oci images generated by yocto
#
oci_tarball_creation_hook() {
    mkdir -p ${DEPLOY_DIR_APPS}

    mkdir -p "${APP_IMAGE_ROOTFS}"

    cp -R "${IMAGE_ROOTFS}/" "${APP_IMAGE_ROOTFS}/"
    cp ${CONTAINER_ENTRYPOINT} "${APP_IMAGE_ROOTFS}/rootfs/entrypoint.sh"
    chmod 755 "${APP_IMAGE_ROOTFS}/rootfs/entrypoint.sh"
    cp ${RUNC_CONFIG} "${APP_IMAGE_ROOTFS}/config.json"
    if [ "${AUTOLAUNCH}" -eq "1" ]; then
        touch "${APP_IMAGE_ROOTFS}/autolaunch"
    fi

    # Remove useless files (update-alternatives, terminfo, bashbug, /etc/...)
    rm -rf ${APP_IMAGE_ROOTFS}/rootfs/usr/lib/opkg \
    ${APP_IMAGE_ROOTFS}/rootfs/var/cache/dnf/ \
    ${APP_IMAGE_ROOTFS}/rootfs/var/lib/dnf \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/dnf \
    ${APP_IMAGE_ROOTFS}/rootfs/usr/bin/update-alternatives \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/rpm \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/terminfo \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/default/usbd \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/mtab \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/motd \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/default \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/filesystems \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/fstab \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/host.conf \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/hostname \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/issue \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/issue.net \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/profile \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/shells \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/skel \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/rcS.d \
    ${APP_IMAGE_ROOTFS}/rootfs/etc/init.d \
    ${APP_IMAGE_ROOTFS}/rootfs/var/tmp \
    ${APP_IMAGE_ROOTFS}/rootfs/var/lib/rpm \
    ${APP_IMAGE_ROOTFS}/rootfs/var/lib/smart \
    ${APP_IMAGE_ROOTFS}/rootfs/var/log \
    ${APP_IMAGE_ROOTFS}/rootfs/var/run \
    ${APP_IMAGE_ROOTFS}/rootfs/var/lock \
    ${APP_IMAGE_ROOTFS}/rootfs/oe_install \

    # Remove unless folder if nothing are inside
    test -f ${APP_IMAGE_ROOTFS}/rootfs/boot && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/boot
    test -f ${APP_IMAGE_ROOTFS}/rootfs/home/root && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/home/root
    test -f ${APP_IMAGE_ROOTFS}/rootfs/home && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/home
    test -f ${APP_IMAGE_ROOTFS}/rootfs/tmp && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/tmp
    test -f ${APP_IMAGE_ROOTFS}/rootfs/mnt && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/mnt
    test -f ${APP_IMAGE_ROOTFS}/rootfs/sys && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/sys
    test -f ${APP_IMAGE_ROOTFS}/rootfs/run && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/run
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/include && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/include
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/sbin && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/sbin
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/bin && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/bin
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/lib && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/lib
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/share/dict && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/share/dict
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/share/man && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/share/man
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/share/misc && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/share/misc
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/share/info && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/share/info
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/share && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/share
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/games && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/games
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr/src && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr/src
    test -f ${APP_IMAGE_ROOTFS}/rootfs/usr && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/usr
    test -f ${APP_IMAGE_ROOTFS}/rootfs/media && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/media
    test -f ${APP_IMAGE_ROOTFS}/rootfs/var/volatile && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/var/volatile
    test -f ${APP_IMAGE_ROOTFS}/rootfs/var/local && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/var/local
    test -f ${APP_IMAGE_ROOTFS}/rootfs/var/spool && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/var/spool
    test -f ${APP_IMAGE_ROOTFS}/rootfs/var/backups && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/var/backups
    test -f ${APP_IMAGE_ROOTFS}/rootfs/var/lib/misc && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/var/lib/misc
    test -f ${APP_IMAGE_ROOTFS}/rootfs/var/lib && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/var/lib
    test -f ${APP_IMAGE_ROOTFS}/rootfs/var && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/var
    test -f ${APP_IMAGE_ROOTFS}/rootfs/oe_install/tmp && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/oe_install/tmp
    test -f ${APP_IMAGE_ROOTFS}/rootfs/oe_install/tmp && rmdir --ignore-fail-on-non-empty ${APP_IMAGE_ROOTFS}/rootfs/oe_install

    return 0
}

do_stage_app_image() {
    mkdir -p ${DEPLOY_DIR_APPS}
    cp ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.tar.gz ${DEPLOY_DIR_APPS}
}

inherit image image-container

addtask do_stage_app_image after do_image_complete before do_build

# Force tar command to use correct rootfs
IMAGE_CMD_tar = "${IMAGE_CMD_TAR} -cvf ${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.tar -C ${APP_IMAGE_ROOTFS} ."

IMAGE_FSTYPES = "tar.gz"
