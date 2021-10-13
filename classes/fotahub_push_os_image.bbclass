inherit fotahub


do_pull_remote_ostree_image[depends] = " \
    ostree-native:do_populate_sysroot \
"

do_push_image_ostree[recrdeptask] = "do_pull_remote_ostree_image"
do_push_image_ostree[depends] = " \
    curl-native:do_populate_sysroot \
    ostree-native:do_populate_sysroot \
"

do_pull_remote_ostree_image() {

    ostree_init_if_non_existent ${OSTREE_REPO} archive-z2

    # Add missing remotes
    ostree_remote_add_if_not_present ${OSTREE_REPO} ${OSTREE_BRANCHNAME} ${OSTREE_HTTP_ADDRESS}

    # Pull locally the remote repo
    set +e
    # Ignore error for this command, since the remote repo could be empty and we have no way to know
    bbnote "Pull locally the repository: ${OSTREE_BRANCHNAME}"
    ostree_pull_mirror ${OSTREE_REPO} ${OSTREE_BRANCHNAME} ${OSTREE_MIRROR_PULL_DEPTH} ${OSTREE_MIRROR_PULL_RETRIES}
    set -e
}

do_push_image_ostree() {
    ostree_push ${OSTREE_REPO} ${OSTREE_BRANCHNAME}
}

IMAGE_CMD_ostreepush() {
    # Do nothing
}

addtask do_pull_remote_ostree_image after do_rootfs before do_image_ostree
addtask do_push_image_ostree after do_image_ostree before do_image_ostreepush
