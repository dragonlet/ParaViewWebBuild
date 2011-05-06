
set(pwservice_name    "PWService")
set(pwservice_version ${PWSOURCE_VER})
set(pwservice_proj    "${pwservice_name}-${pwservice_version}")
set(pwservice_prefix  "${CMAKE_INSTALL_PREFIX}/${pwservice_name}")

ExternalProject_Add(${pwservice_proj}
  DOWNLOAD_COMMAND ""
  SOURCE_DIR  ${PWSOURCE_HOME}
  INSTALL_DIR ${pwservice_prefix}
  LIST_SEPARATOR ::
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
             -DCMAKE_BUILD_TYPE=Debug
             -DBUILD_WEB_SERVICE:BOOL=ON
             -DBUILD_WEB_APPLICATION:BOOL=ON
             -DBUILD_WEB_SAMPLES:BOOL=ON
             -DBUILD_SANDBOX_SAMPLE:BOOL=ON
             -DBUILD_CONSOLE_SAMPLE:BOOL=ON
             -DBUILD_FLEX_RENDERER:BOOL=ON
             -DBUILD_MANTA_SAMPLE:BOOL=ON
             -DANT_EXECUTABLE:FILEPATH=${ANT_EXE}
             -DGWT_SDK_HOME:PATH=${GWT_PREFIX}
             -DQOOXDOO_SDK_PATH:PATH=${QOOXDOO_PREFIX}
             -DJAVA_ARCHIVE:FILEPATH=${Java_JAR_EXECUTABLE}
             -DJAVA_RUNTIME:FILEPATH=${Java_JAVA_EXECUTABLE}
             -DJAVA_COMPILE:FILEPATH=${Java_JAVAC_EXECUTABLE}
             -DACTIVEMQ_CPP:FILEPATH=${ACTIVEMQ_CPP_PREFIX}/lib/libactivemq-cpp.so
             -DACTIVEMQ_INCLUDE_DIR=${ACTIVEMQ_CPP_PREFIX}/include/${ACTIVEMQ_CPP}
             -DCORE_CTX_ROOT=PWService
             -DCORE_SERVICE_URL="http://localhost:8585/PWService"
             -DFLEX_HOME:PATH=${FLEX_SDK_PREFIX}
             -DLOGGING_LEVEL=ERROR
             -DLOG_PARAVIEW:BOOL=OFF
             -DLOG_PARAWEB:BOOL=ON
             -DPV_ADAPTER_EXEC:PATH=${PWSERVER_HOME}/bin/PWServer
             -DTOMCAT_HOME:PATH=${TOMCAT_PREFIX}
             -DWEB_DEPLOY:BOOL=ON
             -DParaView_DIR:PATH=${ParaView_DIR}
             -DCMAKE_MODULE_PATH:PATH=${ParaView_DIR}
             -DCMAKE_INSTALL_RPATH:PATH=${pwservice_prefix}/lib::${ParaView_DIR}::${ACTIVEMQ_CPP_PREFIX}/lib::${PYTHON_LIBRARY_DIR}
             -DWORKING_DIR=<INSTALL_DIR>/PW-work/
  BUILD_COMMAND ${BUILD_CMD_SMP}  
  DEPENDS ${PWSERVER} ${FLEX_SDK} ${GWT} ${ACTIVEMQ_CPP} ${QOOXDOO}
)

ExternalProject_Add_Step(${pwservice_proj} "deploy-war"
    COMMAND ${BUILD_CMD} deploy
    WORKING_DIRECTORY <BINARY_DIR>
    DEPENDEES install
)

ExternalProject_Add_Step(${pwservice_proj} "install-scripts"
    COMMAND ${CMAKE_COMMAND} -DINSTALL_DIR=${CMAKE_INSTALL_PREFIX}
                             -DParaView_DIR=${ParaView_DIR}
                             -DPYTHON_HOME=${PYTHON_HOME}
                             -DJAVA_HOME=${JAVA_HOME}
                             -P scripts.cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDEES install
)

ExternalProject_Get_Property(${pwservice_proj} source_dir binary_dir install_dir)

set(PWSERVICE      ${pwservice_proj}  PARENT_SCOPE)
set(PWSERVICE_HOME ${install_dir}     PARENT_SCOPE)
set(PWSERVICE_LIB  ${install_dir}/lib PARENT_SCOPE)
