require weston.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://weston.ini \
"

do_install_append() {
    install -d ${D}/${sysconfdir}/xdg/weston
    # install weston.ini as sample settings of gl-renderer
    install -m 644 ${WORKDIR}/weston.ini ${D}/${sysconfdir}/xdg/weston/

    # Checking for ivi-shell configuration
    # If ivi-shell is enable, we will add its configs to weston.ini
    if [ "X${USE_WAYLAND_IVI_SHELL}" = "X1" ]; then
        sed -i '/repaint-window=34/c\repaint-window=34\nshell=ivi-shell.so' \
            ${D}/${sysconfdir}/xdg/weston/weston.ini
        sed -e '$a\\' \
            -e '$a\[ivi-shell]' \
            -e '$a\ivi-module=ivi-controller.so' \
            -e '$a\ivi-input-module=ivi-input-controller.so' \
            -e '$a\transition-duration=300' \
            -e '$a\cursor-theme=default' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi
}

FILES_${PN}_append = " \
    ${sysconfdir}/xdg/weston/weston.ini \
"
