inherit ostree

do_pull_os_image_from_fotahub[depends] = " \
    ostree-native:do_populate_sysroot \
"

do_push_os_image_to_fotahub[recrdeptask] = "do_pull_os_image_from_fotahub"
do_push_os_image_to_fotahub[depends] = " \
    curl-native:do_populate_sysroot \
    ostree-native:do_populate_sysroot \
"

do_pull_os_image_from_fotahub() {
    bbnote "Initializing OSTree repo at ${OSTREE_REPO}"
    ostree_init_if_non_existent ${OSTREE_REPO} archive-z2

    bbnote "Adding '${FOTAHUB_OSTREE_REMOTE_NAME}' remote for '${FOTAHUB_OSTREE_URL}' to OSTree repo in ${OSTREE_REPO}"
    ostree_remote_add_if_not_present ${OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${FOTAHUB_OSTREE_URL}

    set +e
    # Ignore error for this command, since the remote repo could be empty and we have no way to know
    bbnote "Pulling '${OSTREE_BRANCHNAME}' OS from remote OSTree repo at FotaHub"
    ostree_pull_mirror ${OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${OSTREE_BRANCHNAME} ${OSTREE_MIRROR_PULL_DEPTH} ${OSTREE_MIRROR_PULL_RETRIES}
    set -e
}

IMAGE_CMD_ostreecommit () {
    echo "Hello"
    ostree_init_if_non_existent ${OSTREE_REPO} archive-z2
    echo "OSTree init done"

    # Commit the result using an explicit commit timestamp so as to avoid to end up with commits dating from a long time ago
    # due to interference with SOURCE_DATE_EPOCH initialized by reproducible_build.bbclass
    # (see https://github.com/ostreedev/ostree/blob/490f515e189d1da4a0e04cc12b7a5e58e5a924dd/src/libostree/ostree-repo-commit.c#L3042 for details)
    ostree_target_hash=$(ostree --repo=${OSTREE_REPO} commit \
           --tree=dir=${OSTREE_ROOTFS} \
           --skip-if-unchanged \
           --branch=${OSTREE_BRANCHNAME} \
           --subject="${OSTREE_COMMIT_SUBJECT}" \
           --body="${OSTREE_COMMIT_BODY}" \
           --add-metadata-string=version="${OSTREE_COMMIT_VERSION}" \
           --timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
           ${EXTRA_OSTREE_COMMIT})

    echo $ostree_target_hash > ${WORKDIR}/ostree_manifest

    if [ ${@ oe.types.boolean('${OSTREE_UPDATE_SUMMARY}')} = True ]; then
        ostree --repo=${OSTREE_REPO} summary -u
    fi
}

IMAGE_CMD_ostreepush() {
    # Do nothing
}

do_push_os_image_to_fotahub() {
    bbnote "Pushing '${PN}' OS image to remote OSTree repo at FotaHub"
    ostree_push_to_fotahub ${OSTREE_REPO} ${OSTREE_BRANCHNAME}
}

addtask do_pull_os_image_from_fotahub after do_rootfs before do_image_ostree
addtask do_push_os_image_to_fotahub after do_image_ostreecommit before do_image_ostreepush
