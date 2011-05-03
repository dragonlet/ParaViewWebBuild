
set(pwserver_name    "PWServer")
set(pwserver_version ${PWSOURCE_VER})
set(pwserver_proj    "${pwserver_name}-${pwserver_version}")
set(pwserver_prefix  "${CMAKE_INSTALL_PREFIX}/${pwserver_name}")

ExternalProject_Add(${pwserver_proj}
  DOWNLOAD_COMMAND ""
  SOURCE_DIR  ${PWSOURCE_HOME}
  INSTALL_DIR ${pwserver_prefix}
  LIST_SEPARATOR ::
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
             -DCMAKE_BUILD_TYPE=Debug
             -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
             -DACTIVEMQ_CPP:FILEPATH=${ACTIVEMQ_CPP_PREFIX}/lib/libactivemq-cpp.so
             -DACTIVEMQ_INCLUDE_DIR:PATH=${ACTIVEMQ_CPP_PREFIX}/include/${ACTIVEMQ_CPP}
             -DBUILD_PW_SERVER:BOOL=ON
             -DBUILD_TESTING:BOOL=ON
             -DBUILD_WEB_SERVICE:BOOL=OFF
             -DParaView_DIR:PATH=${ParaView_DIR}
             -DCMAKE_MODULE_PATH:PATH=${ParaView_DIR}
             -DCMAKE_INSTALL_RPATH:PATH=${pwserver_prefix}/lib::${ParaView_DIR}::${ACTIVEMQ_CPP_PREFIX}/lib::${PYTHON_LIBRARY_DIR}
  BUILD_COMMAND ${BUILD_CMD_SMP}
  DEPENDS ${ACTIVEMQ_CPP} ${PWSOURCE}
)

ExternalProject_Get_Property(${pwserver_proj} source_dir binary_dir install_dir)

set(PWSERVER      ${pwserver_proj}   PARENT_SCOPE)
set(PWSERVER_HOME ${install_dir}     PARENT_SCOPE)
set(PWSERVER_LIB  ${install_dir}/lib PARENT_SCOPE)
