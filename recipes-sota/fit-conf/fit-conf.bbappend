# FIT image configuration naming has changed 
# from 'conf@xxx.dtb' / 'conf@overlays_yyy.dtbo' 
# to 'conf-xxx.dtb' / 'conf-overlays_yyy.dtbo'
do_install() {
	mkdir -p ${D}${libdir}
	echo -n "fit_conf=" >${D}${libdir}/fit_conf

	if [ -n ${SOTA_MAIN_DTB} ]; then
		echo -n "#conf-${SOTA_MAIN_DTB}" >> ${D}${libdir}/fit_conf
	fi

	for ovrl in ${SOTA_DT_OVERLAYS}; do
		echo -n "#conf-overlays_${ovrl}" >> ${D}${libdir}/fit_conf
	done

	for conf_frag in ${SOTA_EXTRA_CONF_FRAGS}; do
		echo -n "#${conf_frag}" >> ${D}${libdir}/fit_conf
	done
}