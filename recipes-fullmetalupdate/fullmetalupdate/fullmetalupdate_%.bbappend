SRC_URI += "file://001-separate-ostree-hawkbit-hosts.patch;subdir=git"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Redefine unpacked recipe source code location (S) according to the Git fetcher's default checkout location (destsuffix)
# (see https://docs.yoctoproject.org/bitbake/bitbake-user-manual/bitbake-user-manual-fetching.html#git-fetcher-git for details)
S = "${WORKDIR}/git"