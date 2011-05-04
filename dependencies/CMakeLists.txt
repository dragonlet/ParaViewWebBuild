# Dependencies
# Packages
#

find_program(apr_conf apr-1-config HINTS /usr/bin)
find_program(apu_conf apu-1-config HINTS /usr/bin)


if (apr_conf)
    execute_process( COMMAND ${apr_conf} --version
                     OUTPUT_VARIABLE apr_ver
                     RESULT_VARIABLE apr_result
    )
else(apr_conf)
    set (apr_ver "0.0.0")
endif(apr_conf)

if (apu_conf)
    execute_process( COMMAND ${apu_conf} --version
                     OUTPUT_VARIABLE apu_ver
                     RESULT_VARIABLE apu_result
    )
else(apu_conf)
    set (apu_ver "0.0.0")
endif(apu_conf)

if (${apr_ver} LESS "1.3.0")
    set(apr_name    "apr")
    set(apr_version "1.3.12")
    set(apr_proj    "${apr_name}-${apr_version}")
    set(apr_prefix  "${CMAKE_INSTALL_PREFIX}")
    set(apr_url     "http://www.apache.org/dist/apr/${apr_proj}.tar.bz2")
    CheckMirrors(${apr_proj} ${apr_url})
    
    ExternalProject_Add(${apr_proj}
      URL ${${apr_proj}_pkg}
      INSTALL_DIR ${apr_prefix}
      CONFIGURE_COMMAND <SOURCE_DIR>/configure
                        --prefix=<INSTALL_DIR>
      #BUILD_IN_SOURCE 1
      BUILD_COMMAND ${BUILD_CMD_SMP}
    )
    set(apr_conf ${apr_prefix}/bin/apr-1-config CACHE FILEPATH "" FORCE)
endif ()

if (${apu_ver} LESS "1.3.0")    
    set(apr_util_name    "apr-util")
    set(apr_util_version "1.3.9")
    set(apr_util_proj    "${apr_util_name}-${apr_util_version}")
    set(apr_util_prefix  "${CMAKE_INSTALL_PREFIX}")
    set(apr_util_url     "http://www.apache.org/dist/apr/${apr_util_proj}.tar.bz2")
    CheckMirrors(${apr_util_proj} ${apr_util_url})
    
    ExternalProject_Add(${apr_util_proj}
      URL ${${apr_util_proj}_pkg}
      INSTALL_DIR ${apr_util_prefix}
      CONFIGURE_COMMAND <SOURCE_DIR>/configure
                        --prefix=<INSTALL_DIR>
                        --with-apr=${apr_prefix}
      #BUILD_IN_SOURCE 1
      BUILD_COMMAND ${BUILD_CMD_SMP}
      DEPENDS ${apr_proj}
    )
    set(apu_conf ${apr_util_prefix}/bin/apu-1-config CACHE FILEPATH "" FORCE)
endif ()

# apache-activemq
set(activemq_name      "activemq")
set(activemq_version   "5.3.2")
set(activemq_proj      "${activemq_name}-${activemq_version}")
set(activemq_prefix    "${CMAKE_INSTALL_PREFIX}/${activemq_proj}")
set(activemq_url       "http://apache.fastbull.org/activemq/apache-${activemq_name}/${activemq_version}/apache-${activemq_proj}-bin.tar.gz")
CheckMirrors(${activemq_proj} ${activemq_url})

ExternalProject_Add(${activemq_proj}
  URL ${${activemq_proj}_pkg}
  INSTALL_DIR ${activemq_prefix}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""  
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>
)
set(ACTIVEMQ_PREFIX ${activemq_prefix} PARENT_SCOPE)

set(activemq_cpp_name    "activemq-cpp")
set(activemq_cpp_version "3.1.3")
set(activemq_cpp_proj    "${activemq_cpp_name}-${activemq_cpp_version}")
set(activemq_cpp_prefix  "${CMAKE_INSTALL_PREFIX}")
set(activemq_cpp_url     "http://mirror.atlanticmetro.net/apache/activemq/activemq-cpp/source/${activemq_cpp_name}-library-${activemq_cpp_version}-src.tar.gz")
CheckMirrors(${activemq_cpp_proj} ${activemq_cpp_url})

ExternalProject_Add(${activemq_cpp_proj}
  URL ${${activemq_cpp_proj}_pkg}
  INSTALL_DIR ${activemq_cpp_prefix}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --with-apr=${apr_conf}
                    --with-apr-util=${apu_conf}
  #BUILD_IN_SOURCE 1
  BUILD_COMMAND ${BUILD_CMD_SMP}
  #DEPENDS ${apr_util_proj}
)
set(ACTIVEMQ_CPP ${activemq_cpp_proj}          PARENT_SCOPE)
set(ACTIVEMQ_CPP_PREFIX ${activemq_cpp_prefix} PARENT_SCOPE)

find_program (ANT_EXE ant /usr/bin)
if (NOT ANT_EXE)
    set(ant_name    "ant")
    set(ant_version "1.8.2")
    set(ant_proj    "${ant_name}-${ant_version}")
    set(ant_prefix  "${CMAKE_INSTALL_PREFIX}/ant")
    set(ant_url     "http://archive.apache.org/dist/ant/binaries/apache-${ant_proj}-bin.tar.bz2")
    CheckMirrors(${ant_proj} ${ant_url})
    
    ExternalProject_Add(${ant_proj}
      URL ${${ant_proj}_pkg}
      INSTALL_DIR ${ant_prefix}
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""  
      INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>
    )
    set(ANT_PREFIX ${ant_prefix}         PARENT_SCOPE)
    set(ANT_EXE    ${ant_prefix}/bin/ant CACHE FILEPATH "Path to ant executable" FORCE)
endif (NOT ANT_EXE)

set(TOMCAT_PREFIX ${CMAKE_INSTALL_PREFIX}/tomcat CACHE PATH "Tomcat prefix" FORCE)
if (TOMCAT_INSTALL)
    set(tomcat_name    "tomcat")
    set(tomcat_version "6.0.32")
    set(tomcat_proj    "${tomcat_name}-${tomcat_version}")
    set(tomcat_url     "http://apache.infocom.ua/tomcat/tomcat-6/v${tomcat_version}/bin/apache-${tomcat_proj}.tar.gz")
    CheckMirrors(${tomcat_proj} ${tomcat_url})
    
    ExternalProject_Add(${tomcat_proj}
      URL ${${tomcat_proj}_pkg}
      INSTALL_DIR ${TOMCAT_PREFIX}
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""  
      INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>
    )
endif (TOMCAT_INSTALL)
