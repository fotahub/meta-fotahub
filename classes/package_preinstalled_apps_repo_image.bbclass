inherit ostree

LICENSE ?= "MIT"

PREINSTALLED_APPS ?= ""

APPS_PACKAGE_NAME = "apps"

APPS_OSTREE_PULL_DEPTH = "1"

# Add dependencies to all applications
python() {
    dependencies = " " + get_app_dependencies(d)
    d.appendVarFlag('do_initialize_ostree_apps', 'depends', dependencies)
    d.appendVarFlag('do_create_apps_package', 'depends', dependencies)
}

def get_app_dependencies(d):
    dependencies = []
    apps = (d.getVar('PREINSTALLED_APPS', True) or "").split()
    for app in apps:
        if app not in dependencies:
            dependencies.append(app)

    dependencies_string = ""
    for dependency in dependencies:
        dependencies_string += " " + dependency + ":do_build"
    return dependencies_string

do_initialize_ostree_apps() {
    rm -rf ${WORKDIR}/${APPS_PACKAGE_NAME}
    rm -rf ${IMAGE_ROOTFS}
    mkdir -p ${IMAGE_ROOTFS}
    rm -f ${WORKDIR}/${PN}-manifest

    bbnote "Initializing a new ostree : ${IMAGE_ROOTFS}/ostree_repo"
    ostree_init ${IMAGE_ROOTFS}/ostree_repo bare-user-only
}

do_create_apps_package[depends] = " \
    ostree-native:do_populate_sysroot \
"

do_initialize_ostree_apps[depends] = " \
    ostree-native:do_populate_sysroot \
"

do_create_apps_package() {
    for app in ${PREINSTALLED_APPS}; do
        bbnote "Add remote for ostree : ${app} ${OSTREE_HTTP_ADDRESS} ${IMAGE_ROOTFS}"
        ostree_remote_add ${IMAGE_ROOTFS}/ostree_repo ${app} ${OSTREE_HTTP_ADDRESS}
        bbnote "Pull the app: remote ${app} branch name ${app} from the repo"
        ostree_pull ${IMAGE_ROOTFS}/ostree_repo ${app} ${APPS_OSTREE_PULL_DEPTH}
        echo ${app} >> ${IMAGE_ROOTFS}/${IMAGE_NAME}-apps.manifest
    done

    ln -sf ${IMAGE_NAME}-apps.manifest ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-apps.manifest
}

do_copy_app() {
    mkdir -p ${DEPLOY_DIR_APPS}
    for type in ${IMAGE_FSTYPES}; do
        cp ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.${type} ${DEPLOY_DIR_APPS}/.
    done
}

addtask create_apps_package after do_rootfs before do_image
addtask copy_app after do_image_complete before do_build

# Allow us to generate image using IMAGE_FSTYPES
inherit image

# Remove useless task
fakeroot python do_rootfs() {
}

addtask do_initialize_ostree_apps after do_rootfs before do_create_apps_package

do_image[noexec] = "1"
do_image_qa[noexec] = "1"
