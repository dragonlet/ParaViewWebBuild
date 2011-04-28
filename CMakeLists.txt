# Add-on CSE_WEB Packages
#

cmake_minimum_required(VERSION 2.8.3)

project(CSE_WEB)

set(PACKAGE_VERSION "2011-04-18")

# Enable testing and dashboard driving:
#
enable_testing()
include(CTest)

# Enable ExternalProject
#
include(ExternalProject)
set(base "${CMAKE_BINARY_DIR}/EP")
set_property(DIRECTORY PROPERTY EP_BASE ${base})

find_path(CSE_HOME Release    $ENV{CSE_HOME} /usr/cta/CSE $ENV{HOME}/CSE)
set (CMAKE_INSTALL_PREFIX     $ENV{HOME}/PVWeb CACHE PATH "Package Install Path" FORCE)
set (CMAKE_BUILD_TYPE         "Debug" CACHE STRING "Type of Build" FORCE)
set (TARBALL_SERVERS          "https://hsai-dev/tarballs" CACHE STRING "URL tarballs server")
set (TARBALLS_DIRS            $ENV{HOME}/tarballs ${CMAKE_SOURCE_DIR}/tarballs CACHE PATH "Source tarballs directories")
set (DOWNLOAD_DIR             ${base}/Download CACHE PATH "Source package download directory")

option(PV_DEV_BUILD "Build ParaView Development"   ON)
option(PV_MESA      "Build ParaView with mesa OS" OFF)
option(WITH_CSE     "Build with CSE"               ON)

if ( CSE_HOME AND WITH_CSE)
    list(APPEND CMAKE_MODULE_PATH "${CSE_HOME}/Misc/CMake") 
    find_package(CSE)
endif ()

FIND_PACKAGE(Java)
FIND_PACKAGE(PythonInterp)
FIND_PACKAGE(PythonLibs)
get_filename_component(PYTHON_LIBRARY_DIR  ${PYTHON_LIBRARY} PATH)

set (ENV{PATH}               "${CMAKE_INSTALL_PREFIX}/bin:${PYTHON_HOME}/bin:$ENV{PATH}")
set (ENV{LD_LIBRARY_PATH}    "${CMAKE_INSTALL_PREFIX}/lib:${ParaView_DIR}:$ENV{LD_LIBRARY_PATH}")
set (ENV{CMAKE_PREFIX_PATH}  "${CMAKE_INSTALL_PREFIX}:${PYTHON_HOME}:$ENV{HOME}/tools/base")

include(${CMAKE_SOURCE_DIR}/cmake/macros.cmake)

# Packages
#
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

#return()

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
                    --with-apr=${apr_prefix}
                    --with-apr-util=${apr_util_prefix}
  #BUILD_IN_SOURCE 1
  BUILD_COMMAND ${BUILD_CMD_SMP}
  DEPENDS ${apr_util_proj}
)

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

set(tomcat_name    "tomcat")
set(tomcat_version "6.0.32")
set(tomcat_proj    "${tomcat_name}-${tomcat_version}")
set(tomcat_prefix  "${CMAKE_INSTALL_PREFIX}/tomcat")
set(tomcat_url     "http://apache.infocom.ua/tomcat/tomcat-6/v${tomcat_version}/bin/apache-${tomcat_proj}.tar.gz")
CheckMirrors(${tomcat_proj} ${tomcat_url})

ExternalProject_Add(${tomcat_proj}
  URL ${${tomcat_proj}_pkg}
  INSTALL_DIR ${tomcat_prefix}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""  
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>
)

#add_subdirectory(paraview-release EXCLUDE_FROM_ALL)

if (PV_DEV_BUILD)
    add_subdirectory(paraview-devel)
endif()

add_subdirectory(pwsource)
add_subdirectory(pwserver)

set(flex_sdk_name    "flex_sdk")
set(flex_sdk_version "3.5.0.12683")
set(flex_sdk_proj    "${flex_sdk_name}_${flex_sdk_version}")
set(flex_sdk_prefix  "${CMAKE_INSTALL_PREFIX}/flex-sdk")
set(flex_sdk_url     "http://fpdownload.adobe.com/pub/flex/sdk/builds/flex3/${flex_sdk_proj}.zip")
CheckMirrors(${flex_sdk_proj} ${flex_sdk_url})

ExternalProject_Add(${flex_sdk_proj}
  URL ${${flex_sdk_proj}_pkg}
  INSTALL_DIR ${flex_sdk_prefix}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""  
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>
)

set(gwt_name    "gwt")
set(gwt_version "2.2.0")
set(gwt_proj    "${gwt_name}-${gwt_version}")
set(gwt_prefix  "${CMAKE_INSTALL_PREFIX}/${gwt_proj}")
set(gwt_url     "http://google-web-toolkit.googlecode.com/files/${gwt_proj}.zip")
CheckMirrors(${gwt_proj} ${gwt_url})

ExternalProject_Add(${gwt_proj}
  URL ${${gwt_proj}_pkg}
  INSTALL_DIR ${gwt_prefix}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""  
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>
  DEPENDS ${ant_proj}
)

set(qooxdoo_name    "qooxdoo")
set(qooxdoo_version "1.4")
set(qooxdoo_proj    "${qooxdoo_name}-${qooxdoo_version}")
set(qooxdoo_prefix  "${CMAKE_INSTALL_PREFIX}/${qooxdoo_proj}-sdk")
set(qooxdoo_url     "http://sourceforge.net/settings/mirror_choices?projectname=qooxdoo&filename=qooxdoo-current/${qooxdoo_version}/${qooxdoo_proj}-sdk.zip")
CheckMirrors(${qooxdoo_proj} ${qooxdoo_url})

ExternalProject_Add(${qooxdoo_proj}
  URL ${${qooxdoo_proj}_pkg}
  INSTALL_DIR ${qooxdoo_prefix}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""  
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR> <INSTALL_DIR>
  DEPENDS
)

add_subdirectory(pwservice)

