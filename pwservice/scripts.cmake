#

set(PVWEB_HOME ${INSTALL_DIR})


configure_file( run_pw.sh.in
                ${INSTALL_DIR}/run_pw.sh @ONLY)

configure_file( use_pvweb.sh.in
                ${INSTALL_DIR}/use_pvweb.sh @ONLY)

file(COPY findPort.sh manta-init.py DESTINATION ${INSTALL_DIR}/bin)

foreach (cmd_file manta.sh
                  PWServer.sh
                  pw_default.sh
                  pw_parallel.sh
                  pw_pvserver.sh
                  cse_pvserver.sh
        )          
    configure_file( ${cmd_file}.in
                    ${INSTALL_DIR}/bin/${cmd_file} @ONLY)
endforeach()

configure_file( plugins/MantaLoader.py.in
                ${WORKING_DIR}/plugins/MantaLoader.py @ONLY)

configure_file( plugins/Calc.py
                ${WORKING_DIR}/plugins/Calc.py COPYONLY)