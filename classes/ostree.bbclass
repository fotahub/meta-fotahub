SYSTEM_CACERT_BUNDLE ?= "/etc/ssl/certs/ca-certificates.crt"

FOTAHUB_OSTREE_HOSTNAME = "delta.fotahub.com"
FOTAHUB_OSTREE_PORT = "443"
FOTAHUB_OSTREE_URL = "https://${FOTAHUB_OSTREE_HOSTNAME}:${FOTAHUB_OSTREE_PORT}"
FOTAHUB_OSTREEPUSH_PORT = "1155"
FOTAHUB_OSTREEPUSH_URL = "ssh://${FOTAHUB_OSTREEPUSH_USER}@${FOTAHUB_OSTREE_HOSTNAME}:${FOTAHUB_OSTREEPUSH_PORT}/ostree/repo"
FOTAHUB_OSTREE_REMOTE_NAME = "fotahub"

OSTREE_GPG_VERIFY ?= "false"

OSTREE_MIRROR_PULL_RETRIES = "10"
OSTREE_MIRROR_PULL_DEPTH = "0"

python __anonymous() {
    ostree_repo_path = d.getVar('OSTREE_REPO')
    if not ostree_repo_path:
        bb.fatal("OSTREE_REPO should be set in your local.conf")

    ostree_branch_name = d.getVar('OSTREE_BRANCHNAME')
    if not ostree_branch_name:
        bb.fatal("OSTREE_BRANCHNAME should be set in your local.conf")

    fotahub_ostree_ssh_user = d.getVar('FOTAHUB_OSTREEPUSH_USER')
    if not fotahub_ostree_ssh_user:
        bb.fatal("FOTAHUB_OSTREEPUSH_USER should be set in your local.conf")
 
    fotahub_ostree_ssh_pass = d.getVar('FOTAHUB_OSTREEPUSH_PASS')
    if not fotahub_ostree_ssh_pass:
        bb.fatal("FOTAHUB_OSTREEPUSH_PASS should be set in your local.conf")
}

ostree_init() {
    local ostree_repo_path="$1"
    local ostree_repo_mode="$2"

    mkdir -p `dirname ${ostree_repo_path}`
    ostree --repo=${ostree_repo_path} init --mode=${ostree_repo_mode}
}

ostree_init_if_non_existent() {
    local ostree_repo_path="$1"
    local ostree_repo_mode="$2"

    if [ ! -d ${ostree_repo_path} ]; then
        ostree_init ${ostree_repo_path} ${ostree_repo_mode}
    fi
}

ostree_remote_add() {
    local ostree_repo_path="$1"
    local ostree_remote_name="$2"
    local ostree_remote_url="$3"
    
    # Make sure OSTree uses configured root CA certificate instead of non exisiting default root CA certificate bundle at
    # /data/yocto/build/tmp/fotahub-apps/sysroots-components/x86_64/curl-native/etc/ssl/certs/ca-certificates.crt 
    config_opts="--set=tls-ca-path=${SYSTEM_CACERT_BUNDLE}"

    if [ "${OSTREE_GPG_VERIFY}" != "true" ]; then
        gpg_opts="--no-gpg-verify"
    fi
    
    ostree remote add ${config_opts} ${gpg_opts} ${ostree_remote_name} ${ostree_remote_url} --repo=${ostree_repo_path}
}

ostree_remote_delete() {
    local ostree_repo_path="$1"
    local ostree_remote_name="$2"

    ostree remote delete ${ostree_remote_name} --repo=${ostree_repo_path}
}

ostree_is_remote_present() {
    local ostree_repo_path="$1"
    local ostree_remote_name="$2"

    ostree remote list --repo=${ostree_repo_path} | grep -q ${ostree_remote_name}
}

ostree_remote_add_if_not_present() {
    local ostree_repo_path="$1"
    local ostree_remote_name="$2"
    local ostree_remote_url="$3"

    if ! ostree_is_remote_present ${ostree_repo_path} ${ostree_remote_name}; then
        ostree_remote_add ${ostree_repo_path} ${ostree_remote_name} ${ostree_remote_url}
    fi
}

ostree_push_to_fotahub() {
    local ostree_repo_path="$1"
    local ostree_branch_name="$2"

    sshpass -p ${FOTAHUB_OSTREEPUSH_PASS} ostree-push --repo ${ostree_repo_path} ${FOTAHUB_OSTREEPUSH_URL} ${ostree_branch_name}
}

ostree_pull() {
    local ostree_repo_path="$1"
    local ostree_remote_name="$2"
    local ostree_branch_name="$3"
    local ostree_depth="$4"

    # Uncomment to debug underlying cURL operations and HTTP requests/responses
    # export OSTREE_DEBUG_HTTP=y

    ostree pull ${ostree_remote_name} ${ostree_branch_name} --depth=${ostree_depth} --repo=${ostree_repo_path}
}

ostree_pull_mirror() {
    local ostree_repo_path="$1"
    local ostree_remote_name="$2"
    local ostree_branch_name="$3"
    local ostree_depth="$4"
    local ostree_maxretry="$5"
    local ostree_retries=0
    local ostree_timeout_error_pattern="Timeout"

    $(ostree pull ${ostree_remote_name} ${ostree_branch_name} --depth=${ostree_depth} --mirror --repo=${ostree_repo_path} 2>&1 | grep -q ${ostree_timeout_error_pattern}) 

    while ! test $? -gt 0 && [ ${ostree_retries} -le ${ostree_maxretry} ]
    do 
        ostree_retries=$(expr $ostree_retries + 1)
        $(ostree pull ${ostree_remote_name} ${ostree_branch_name} --depth=${ostree_depth} --mirror --repo=${ostree_repo_path} 2>&1 | grep -q ${ostree_timeout_error_pattern}) 
	done 
}

ostree_commit() {
    local ostree_repo_path="$1"
    local ostree_branch_name="$2"
    local ostree_tree_content="$3"
    shift; shift; shift; local ostree_extra_commit_args="$@"

    # Commit the result using an explicit commit timestamp so as to avoid to end up with commits dating from a long time ago
    # due to interference with SOURCE_DATE_EPOCH initialized by reproducible_build.bbclass
    # (see https://github.com/ostreedev/ostree/blob/490f515e189d1da4a0e04cc12b7a5e58e5a924dd/src/libostree/ostree-repo-commit.c#L3042 for details)
    ostree commit \
        --repo=${ostree_repo_path} \
        --branch=${ostree_branch_name} \
        --tree=${ostree_tree_content} \
        --skip-if-unchanged \
        --subject="${OSTREE_COMMIT_SUBJECT}" \
        --body="${OSTREE_COMMIT_BODY}" \
        --timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
        ${ostree_extra_commit_args}
}

ostree_revparse() {
    local ostree_repo_path="$1"
    local ostree_branch_name="$2"

    ostree rev-parse ${ostree_branch_name} --repo=${ostree_repo_path} | head
}