inherit ostree

do_push_app_image_to_fotahub[depends] = " \
    curl-native:do_populate_sysroot \
    ostree-native:do_populate_sysroot \
"

do_push_app_image_to_fotahub() {
    bbnote "Initializing OSTree repo at ${OSTREE_REPO}"
    ostree_init_if_non_existent ${OSTREE_REPO} archive-z2

    bbnote "Adding '${FOTAHUB_OSTREE_REMOTE_NAME}' remote for '${FOTAHUB_OSTREE_URL}' to OSTree repo in ${OSTREE_REPO}"
    ostree_remote_add_if_not_present ${OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${FOTAHUB_OSTREE_URL}

    set +e
    # Ignore errors for this command since the remote OSTree repo could be empty yet which is just fine
    bbnote "Pulling '${PN}' branch from remote OSTree repo at FotaHub"
    ostree_pull_mirror ${OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${PN} ${OSTREE_MIRROR_PULL_DEPTH} ${OSTREE_MIRROR_PULL_RETRIES}
    set -e

    bbnote "Committing '${PN}' application image to OSTree repo at ${OSTREE_REPO}"
    ostree_commit ${OSTREE_REPO} ${PN} tar=${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.tar.gz ${EXTRA_OSTREE_COMMIT}

    bbnote "Pushing '${PN}' branch to remote OSTree repo at FotaHub"
    ostree_push_to_fotahub ${OSTREE_REPO} ${PN}
}

addtask do_push_app_image_to_fotahub after do_image_complete before do_build
