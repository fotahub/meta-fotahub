inherit fotahub

# OSTree application deployment
export OSTREE_PACKAGE_BRANCHNAME = "${PN}"
export OSTREE_REPO_CONTAINERS = "${DEPLOY_DIR_IMAGE}/ostree_repo_containers"

do_push_container_to_ostree[depends] = " \
    curl-native:do_populate_sysroot \
    ostree-native:do_populate_sysroot \
"

do_push_container_to_ostree() {
    if [ -z "$OSTREE_PACKAGE_BRANCHNAME" ]; then
        bbfatal "OSTREE_PACKAGE_BRANCHNAME should be set in your local.conf"
    fi

    ostree_init_if_non_existent ${OSTREE_REPO_CONTAINERS} archive-z2

    # Add missing remotes
    ostree_remote_add_if_not_present ${OSTREE_REPO_CONTAINERS} ${OSTREE_PACKAGE_BRANCHNAME} ${OSTREE_HTTP_ADDRESS}

    #Pull locally the remote repo
    set +e
    # Ignore error for this command, since the remote repo could be empty and we have no way to know
    bbnote "Pull locally the repository: ${OSTREE_PACKAGE_BRANCHNAME}"
    ostree_pull_mirror ${OSTREE_REPO_CONTAINERS} ${OSTREE_PACKAGE_BRANCHNAME} ${OSTREE_MIRROR_PULL_DEPTH} ${OSTREE_MIRROR_PULL_RETRIES}
    set -e

    # Commit the result
    bbnote "Commit locally the build result"
    ostree --repo=${OSTREE_REPO_CONTAINERS} commit \
           --tree=tar=${CONTAINERS_DIRECTORY}/${IMAGE_LINK_NAME}.tar.gz \
           --skip-if-unchanged \
           --branch=${OSTREE_PACKAGE_BRANCHNAME} \
           --subject="Commit-id: ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}"

    ostree_push ${OSTREE_REPO_CONTAINERS} ${OSTREE_PACKAGE_BRANCHNAME}
}

# do_copy_container task defined in oci_image.bbclass
addtask do_push_container_to_ostree after do_copy_container before do_build
