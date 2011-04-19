#

set(PVWEB_HOME ${INSTALL_DIR})

configure_file( run_pw.sh.in
                ${INSTALL_DIR}/run_pw.sh @ONLY)

configure_file( use_pvweb.sh.in
                ${INSTALL_DIR}/use_pvweb.sh @ONLY)
