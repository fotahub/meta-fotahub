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
    bbnote "Pulling '${PN}' application from remote OSTree repo at FotaHub"
    ostree_pull_mirror ${OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${PN} ${OSTREE_MIRROR_PULL_DEPTH} ${OSTREE_MIRROR_PULL_RETRIES}
    set -e

    bbnote "Committing '${PN}' application to OSTree repo at ${OSTREE_REPO}"
    # Use an explicit commit timestamp so as to avoid to end up with commits dating from a long time ago
    # due to interference with SOURCE_DATE_EPOCH initialized by reproducible_build.bbclass
    # (see https://github.com/ostreedev/ostree/blob/490f515e189d1da4a0e04cc12b7a5e58e5a924dd/src/libostree/ostree-repo-commit.c#L3042 for details)
    ostree --repo=${OSTREE_REPO} commit \
           --tree=tar=${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.tar.gz \
           --skip-if-unchanged \
           --branch=${PN} \
           --subject="${OSTREE_COMMIT_SUBJECT}" \
           --body="${OSTREE_COMMIT_BODY}" \
           --timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    bbnote "OSTREE_REPO=${OSTREE_REPO}"
    bbnote "$(ostree --repo=${OSTREE_REPO} log ${PN})"

    bbnote "Pushing '${PN}' application image to remote OSTree repo at FotaHub"
    ostree_push_to_fotahub ${OSTREE_REPO} ${PN}
}

addtask do_push_app_image_to_fotahub after do_image_complete before do_build
