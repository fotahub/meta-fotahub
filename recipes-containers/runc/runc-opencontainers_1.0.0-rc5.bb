HOMEPAGE = "https://github.com/opencontainers/runc"
DESCRIPTION = "CLI tool for spawning and running containers on Linux according to the OCI specification"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = " \
    git://github.com/opencontainers/runc.git;nobranch=1;tag=v${PV};destsuffix=git \
    file://0001-Tolerate-symlinked-rootfs.patch \
"

# Redefine unpacked recipe source code location (S) according to the Git fetcher's default checkout location (destsuffix)
# (see https://docs.yoctoproject.org/bitbake/bitbake-user-manual/bitbake-user-manual-fetching.html#git-fetcher-git for details)
S = "${WORKDIR}/git"

inherit go
inherit goarch

PROVIDES += "virtual/runc"
RPROVIDES_${PN} = "virtual/runc"

GO_IMPORT = "import"

LIBCONTAINER_PACKAGE="github.com/opencontainers/runc/libcontainer"

do_configure[noexec] = "1"

EXTRA_OEMAKE = "BUILDTAGS='' GO=${GO}"

INHIBIT_PACKAGE_STRIP = "1"

do_compile() {
	# Set GOPATH. Don't rely on Docker to download its dependencies but use independently dependencies packaged instead
	cd ${S}
	rm -rf .gopath
	dname=`dirname "${LIBCONTAINER_PACKAGE}"`
	bname=`basename "${LIBCONTAINER_PACKAGE}"`
	mkdir -p .gopath/src/${dname}

	(cd .gopath/src/${dname}; ln -sf ../../../../../${bname} ${bname})
	export GOPATH="${S}/.gopath:${S}/vendor:${STAGING_DIR_TARGET}/${prefix}/local/go"

	# Fix up Go cross compiler symlink
	rm -f ${S}/vendor/src
	ln -sf ./ ${S}/vendor/src

	# Set CGO_CFLAGS/CGO_LDFLAGS so that CGo can find the required headers files and libraries
	export CGO_ENABLED="1"
	export CGO_CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_TARGET}"
	export CGO_LDFLAGS="${LDFLAGS} --sysroot=${STAGING_DIR_TARGET}"
	export GO=${GO}

	export CFLAGS=""
	export LDFLAGS=""
	go version
	oe_runmake static
}

do_install() {
	mkdir -p ${D}/${bindir}

	cp ${S}/runc ${D}/${bindir}/runc
	ln -sf runc ${D}/${bindir}/docker-runc
}
