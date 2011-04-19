
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
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
             -DCMAKE_BUILD_TYPE=Debug
             -DBUILD_WEB_SERVICE=ON
             -DBUILD_WEB_APPLICATION=ON
             -DBUILD_WEB_SAMPLES=ON
             -DBUILD_SANDBOX_SAMPLE=ON
             -DBUILD_CONSOLE_SAMPLE=ON
             -DANT_EXECUTABLE=${ant_prefix}/bin/ant
             -DGWT_SDK_HOME=${gwt_prefix}
             -DQOOXDOO_SDK_PATH=${qooxdoo_prefix}
             -DJAVA_ARCHIVE=/usr/java/jdk6-64/bin/jar
             -DJAVA_RUNTIME=/usr/java/jdk6-64/bin/java
             -DJAVA_COMPILE=/usr/java/jdk6-64/bin/javac
             -DACTIVEMQ_CPP=${activemq_cpp_prefix}/lib/libactivemq-cpp.so
             -DACTIVEMQ_INCLUDE_DIR=${activemq_cpp_prefix}/include/${activemq_cpp_proj}
             -DCORE_CTX_ROOT=PWService
             -DCORE_SERVICE_URL="http://localhost:8585/PWService"
             -DFLEX_HOME=${flex_sdk_prefix}
             -DLOGGING_LEVEL=ERROR
             -DLOG_PARAVIEW=OFF
             -DLOG_PARAWEB=ON
             -DPV_ADAPTER_EXEC=${PWSERVER_HOME}/bin/PWServer
             -DTOMCAT_HOME=${tomcat_prefix}
             -DWEB_DEPLOY=ON
             -DParaView_DIR=${ParaView_DIR}
             -DCMAKE_MODULE_PATH=${ParaView_DIR}
             -DCMAKE_INSTALL_RPATH:PATH=${pwservice_prefix}/lib::${ParaView_DIR}::${activemq_cpp_prefix}/lib::${PYTHON_LIBRARY_DIR}
             -DWORKING_DIR=<INSTALL_DIR>/PW-work/
  BUILD_COMMAND ${BUILD_CMD_SMP}  
  DEPENDS ${PWSERVER} ${flex_sdk_proj} ${tomcat_proj} ${gwt_proj} ${activemq_proj} ${qooxdoo_proj}
)

ExternalProject_Add_Step(${pwservice_proj} "deploy-war"
    #COMMAND /bin/pwd
    COMMAND ${build_cmd} deploy
    WORKING_DIRECTORY <BINARY_DIR>
    DEPENDEES install
)

ExternalProject_Add_Step(${pwservice_proj} "install-scripts"
    COMMAND ${CMAKE_COMMAND} -DINSTALL_DIR=${CMAKE_INSTALL_PREFIX}
                             -DParaView_DIR=${ParaView_DIR}
                             -DPYTHON_HOME=${PYTHON_HOME}
                             -P scripts.cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDEES install
)

ExternalProject_Get_Property(${pwservice_proj} source_dir binary_dir install_dir)

set(PWSERVICE      ${pwservice_proj}  PARENT_SCOPE)
set(PWSERVICE_HOME ${install_dir}     PARENT_SCOPE)
set(PWSERVICE_LIB  ${install_dir}/lib PARENT_SCOPE)
