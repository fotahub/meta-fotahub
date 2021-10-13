SYSTEM_CACERT_BUNDLE ?= "/etc/ssl/certs/ca-certificates.crt"

OSTREE_HOSTNAME = "ostree.fotahub.com"
OSTREE_URL_PORT = "443"
OSTREEPUSH_SSH_PORT = "1110"
OSTREE_HTTP_ADDRESS = "https://${OSTREE_HOSTNAME}:${OSTREE_URL_PORT}"
OSTREE_SSH_ADDRESS = "ssh://${OSTREEPUSH_SSH_USER}@${OSTREE_HOSTNAME}:${OSTREEPUSH_SSH_PORT}/ostree/repo"
OSTREE_GPG_VERIFY ?= ""
OSTREE_MIRROR_PULL_RETRIES = "10"
OSTREE_MIRROR_PULL_DEPTH = "0"
OSTREE_CONTAINER_PULL_DEPTH = "1"

python __anonymous() {
    ostree_repo = d.getVar('OSTREE_REPO')
    if not ostree_repo:
        bb.fatal("OSTREE_REPO should be set in your local.conf")

    ostree_branch_name = d.getVar('OSTREE_BRANCHNAME')
    if not ostree_branch_name:
        bb.fatal("OSTREE_BRANCHNAME should be set in your local.conf")

    ostree_ssh_user = d.getVar('OSTREEPUSH_SSH_USER')
    if not ostree_ssh_user:
        bb.fatal("OSTREEPUSH_SSH_USER should be set in your local.conf")
 
    ostree_ssh_pass = d.getVar('OSTREEPUSH_SSH_PASS')
    if not ostree_ssh_pass:
        bb.fatal("OSTREEPUSH_SSH_PASS should be set in your local.conf")
}

ostree_init() {
    local ostree_repo="$1"
    local ostree_repo_mode="$2"

    ostree --repo=${ostree_repo} init --mode=${ostree_repo_mode}
}

ostree_init_if_non_existent() {
    local ostree_repo="$1"
    local ostree_repo_mode="$2"

    if [ ! -d ${ostree_repo} ]; then
        mkdir -p ${ostree_repo}
        ostree_init ${ostree_repo} ${ostree_repo_mode}
    fi
}

ostree_push() {
    local ostree_repo="$1"
    local ostree_branch="$2"

    bbnote "Push the build result to the remote OSTREE"
    sshpass -p ${OSTREEPUSH_SSH_PASS} ostree-push --repo ${ostree_repo} ${OSTREE_SSH_ADDRESS} ${ostree_branch}
}

ostree_pull() {
    local ostree_repo="$1"
    local ostree_branch="$2"
    local ostree_depth="$3"

    # Uncomment to debug underlying cURL operations and HTTP requests/responses
    # export OSTREE_DEBUG_HTTP=y

    ostree pull ${ostree_branch} ${ostree_branch} --depth=${ostree_depth} --repo=${ostree_repo}
}

ostree_pull_mirror() {
    local ostree_repo="$1"
    local ostree_branch="$2"
    local ostree_depth="$3"
    local ostree_maxretry="$4"
    local lookup="Timeout"
    local counter_retry=0

    $(ostree pull ${ostree_branch} ${ostree_branch} --depth=${ostree_depth} --mirror --repo=${ostree_repo} 2>&1 | grep -q ${lookup}) 

    while ! test $? -gt 0 && [ ${counter_retry} -le ${ostree_maxretry} ]
    do 
        counter_retry=$(expr $counter_retry + 1)
        bbnote "OsTree pull counter retry: ${counter_retry}"
        $(ostree pull ${ostree_branch} ${ostree_branch} --depth=${ostree_depth} --mirror --repo=${ostree_repo} 2>&1 | grep -q ${lookup}) 
	done 
}

ostree_revparse() {
    local ostree_repo="$1"
    local ostree_branch="$2"

    ostree rev-parse ${ostree_branch} --repo=${ostree_repo} | head
}

ostree_remote_add() {
    local ostree_repo="$1"
    local ostree_branch="$2"
    local ostree_http_address="$3"
    
    # Make sure OSTree uses configured root CA certificate instead of non exisiting default root CA certificate bundle at
    # /data/yocto/build/tmp/fullmetalupdate-containers/sysroots-components/x86_64/curl-native/etc/ssl/certs/ca-certificates.crt 
    config_opts="--set=tls-ca-path=${SYSTEM_CACERT_BUNDLE}"

    if [ -z "${OSTREE_GPG_VERIFY}" ]; then
        gpg_opts="--no-gpg-verify"
    fi
    
    ostree remote add ${config_opts} ${gpg_opts} ${ostree_branch} ${ostree_http_address} --repo=${ostree_repo}
}

ostree_remote_delete() {
    local ostree_repo="$1"
    local ostree_branch="$2"

    ostree remote delete ${ostree_branch} --repo=${ostree_repo}
}

ostree_is_remote_present() {
    local ostree_repo="$1"
    local ostree_branch="$2"

    ostree remote list --repo=${ostree_repo} | grep -q ${ostree_branch}
}

ostree_remote_add_if_not_present() {
    local ostree_repo="$1"
    local ostree_branch="$2"
    local ostree_http_address="$3"

    if ! ostree_is_remote_present ${ostree_repo} ${ostree_branch}; then
        ostree_remote_add ${ostree_repo} ${ostree_branch} ${ostree_http_address}
    fi
}