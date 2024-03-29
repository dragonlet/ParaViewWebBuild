# Add-on CSE_WEB Packages
#

cmake_minimum_required(VERSION 2.8)

project(ParaViewWebBuild)

set(PACKAGE_VERSION "2012-04-11")

# Enable testing and dashboard driving:
#
enable_testing()
include(CTest)

# Enable ExternalProject
#
include(ExternalProject)
set(base "${CMAKE_BINARY_DIR}/EP")
set_property(DIRECTORY PROPERTY EP_BASE ${base})

set (PVWEB_INSTALL_PREFIX     $ENV{HOME}/PVWeb CACHE PATH "Package Install Path")
set (CMAKE_INSTALL_PREFIX     ${PVWEB_INSTALL_PREFIX} CACHE INTERNAL "" FORCE)
set (CMAKE_BUILD_TYPE         "Debug" CACHE STRING "Type of Build" FORCE)
#set (TARBALL_SERVERS          "https://hsai-dev/tarballs" CACHE STRING "URL tarballs server")
set (TARBALL_SERVERS          "http://github.com/ktkirk/tarballs/raw/master" CACHE STRING "URL tarballs server")
set (TARBALLS_DIRS            ${CMAKE_SOURCE_DIR}/tarballs $ENV{HOME}/tarballs CACHE PATH "Source tarballs directories")
set (DOWNLOAD_DIR             ${base}/Download CACHE PATH "Source package download directory")

option(PV_DEV_BUILD   "Build ParaView Development"    OFF)
option(PV_OSMESA      "Build ParaView with mesa OS"   OFF)
option(SYSTEM_MESA    "System Mesa"                   OFF)
option(WITH_CSE       "Build with CSE"                OFF)
option(TOMCAT_INSTALL "Install with Tomcat"            ON)
option(PVWEB_GIT      "Build ParaViewWeb Development" OFF)

if (WITH_CSE)
    find_path(CSE_HOME Release    $ENV{CSE_HOME} /usr/cta/CSE $ENV{HOME}/CSE)
    list(APPEND CMAKE_MODULE_PATH "${CSE_HOME}/Misc/CMake") 
    find_package(CSE)
else ()
    include(${CMAKE_SOURCE_DIR}/cmake/build.cmake)
endif ()

FIND_PACKAGE(Java)
if (JAVA_FOUND)
    string(REPLACE "/bin/java" "" JAVA_HOME "${Java_JAVA_EXECUTABLE}")
endif (JAVA_FOUND)

FIND_PACKAGE(PythonInterp)
FIND_PACKAGE(PythonLibs)
if (PYTHONINTERP_FOUND)
    get_filename_component(PYTHON_BIN  ${PYTHON_EXECUTABLE} PATH)
    string(REPLACE "/bin" "" PYTHON_HOME "${PYTHON_BIN}") 
    get_filename_component(PYTHON_LIBRARY_DIR  ${PYTHON_LIBRARY} PATH)
endif (PYTHONINTERP_FOUND)

set (ENV{PATH}               "${CMAKE_INSTALL_PREFIX}/bin:${PYTHON_HOME}/bin:$ENV{PATH}")
set (ENV{LD_LIBRARY_PATH}    "${CMAKE_INSTALL_PREFIX}/lib:${ParaView_DIR}:$ENV{LD_LIBRARY_PATH}")
set (ENV{CMAKE_PREFIX_PATH}  "${CMAKE_INSTALL_PREFIX}:${PYTHON_HOME}:$ENV{HOME}/tools/base")

include(${CMAKE_SOURCE_DIR}/cmake/macros.cmake)

add_subdirectory(dependencies)
add_subdirectory(manta)

if (PV_DEV_BUILD)
    add_subdirectory(paraview-devel)
else()
    add_subdirectory(paraview-release)
endif()

add_subdirectory(pwsource)
add_subdirectory(pwserver)

add_subdirectory(optional)

add_subdirectory(pwservice)
