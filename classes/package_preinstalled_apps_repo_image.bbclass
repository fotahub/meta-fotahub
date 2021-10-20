inherit ostree

LICENSE ?= "MIT"

PREINSTALLED_APPS ?= ""

PREINSTALLED_APPS_OSTREE_REPO = "${IMAGE_ROOTFS}/ostree/repo"
PREINSTALLED_APPS_OSTREE_PULL_DEPTH = "1"

# Add dependencies to all applications
python() {
    dependencies = " " + get_app_dependencies(d)
    d.appendVarFlag('do_populate_preinstalled_apps_ostree_repo', 'depends', dependencies)
}

def get_app_dependencies(d):
    dependencies = []
    apps = (d.getVar('PREINSTALLED_APPS', True) or "").split()
    for app in apps:
        if app not in dependencies:
            dependencies.append(app)

    dependencies_string = ""
    for dependency in dependencies:
        dependencies_string += " " + dependency + ":do_push_app_image_to_fotahub"
    return dependencies_string

do_initialize_preinstalled_apps_ostree_repo() {
    rm -rf ${IMAGE_ROOTFS}

    bbnote "Initializing new OSTree repo at ${PREINSTALLED_APPS_OSTREE_REPO}"
    ostree_init ${PREINSTALLED_APPS_OSTREE_REPO} bare-user-only
}

do_populate_preinstalled_apps_ostree_repo[depends] = " \
    ostree-native:do_populate_sysroot \
"

do_initialize_preinstalled_apps_ostree_repo[depends] = " \
    ostree-native:do_populate_sysroot \
"

do_populate_preinstalled_apps_ostree_repo() {
    for app in ${PREINSTALLED_APPS}; do
        bbnote "Adding '${FOTAHUB_OSTREE_REMOTE_NAME}' remote for '${FOTAHUB_OSTREE_URL}' to OSTree repo in ${PREINSTALLED_APPS_OSTREE_REPO}"
        ostree_remote_add ${PREINSTALLED_APPS_OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${FOTAHUB_OSTREE_URL}

        set +e
        # Ignore errors for this command since the remote OSTree repo could be empty yet which is just fine
        bbnote "Pulling '${app}' application from remote OSTree repo at FotaHub"
        ostree_pull ${PREINSTALLED_APPS_OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${app} ${PREINSTALLED_APPS_OSTREE_PULL_DEPTH}
        set -e

        echo ${app} >> ${IMAGE_ROOTFS}/${IMAGE_NAME}-apps.manifest
    done

    ln -sf ${IMAGE_NAME}-apps.manifest ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-apps.manifest
}

do_stage_preinstalled_apps_ostree_repo_image() {
    mkdir -p ${DEPLOY_DIR_APPS}
    for type in ${IMAGE_FSTYPES}; do
        cp ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.${type} ${DEPLOY_DIR_APPS}
    done
}

addtask do_populate_preinstalled_apps_ostree_repo after do_rootfs before do_image
addtask do_stage_preinstalled_apps_ostree_repo_image after do_image_complete before do_build

# Enable image creation based on IMAGE_FSTYPES
inherit image

# Remove useless task
fakeroot python do_rootfs() {
}

addtask do_initialize_preinstalled_apps_ostree_repo after do_rootfs before do_populate_preinstalled_apps_ostree_repo

do_image[noexec] = "1"
do_image_qa[noexec] = "1"
