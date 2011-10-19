#

set(PVWEB_HOME ${INSTALL_DIR})

# main stripts
foreach (cmd_file start_pw.sh
                  stop_pw.sh
                  use_pvweb.sh
        )
    configure_file( ${cmd_file}.in
                    ${INSTALL_DIR}/${cmd_file} @ONLY)
endforeach()

# bin scripts
foreach (cmd_file manta.sh
                  PWServer.sh
                  pw_default.sh
                  pw_parallel.sh
                  pw_pvserver.sh
                  cse_pvserver.sh
                  start_X.sh
                  stop_X.sh
        )          
    configure_file( ${cmd_file}.in
                    ${INSTALL_DIR}/bin/${cmd_file} @ONLY)
endforeach()

file(COPY findPort.sh manta-init.py DESTINATION ${INSTALL_DIR}/bin)

configure_file( plugins/MantaLoader.py.in
                ${WORKING_DIR}/plugins/MantaLoader.py @ONLY)

configure_file( plugins/Calc.py
                ${WORKING_DIR}/plugins/Calc.py COPYONLY)