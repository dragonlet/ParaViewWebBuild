
set (verbose false)
set (verbose_level 1)

find_program(CURL curl HINTS /usr/bin)

macro (show)
    if (verbose)
        if (${ARGC} EQUAL 1)
            message ("${ARGV0}")
        elseif (${ARGC} GREATER 1)
            message (${ARGV0} "${ARGV1}")
        else (${ARGC} EQUAL 1)
            message ("${ARGVN}")
        endif (${ARGC} EQUAL 1)
    endif (verbose)
endmacro(show)

macro(show_var var level)
  if (${level} LESS verbose_level OR ${level} EQUAL verbose_level )
    message(STATUS "${var}: ${${var}}")
  endif ()  
endmacro(show_var)

macro (mklink dir old new)
    execute_process( COMMAND ${CMAKE_COMMAND} -E create_symlink ${old} ${new}
                    WORKING_DIRECTORY ${dir}
    )
endmacro(mklink)

macro (copyfile src dst)
    configure_file( ${src} ${dst} COPYONLY)
endmacro(copyfile)

macro (loadfile filename)
    file (READ ${filename} file_content)
    string(CONFIGURE "${fire_content}" "${filename}" @ONLY)
endmacro(loadfile)

macro (system_info)
    message(STATUS "Host Name:      $ENV{HOSTNAME}")
    message(STATUS "System Name:    ${CMAKE_HOST_SYSTEM}\t| ${CMAKE_SYSTEM}")
    message(STATUS "System OS:      ${CMAKE_HOST_SYSTEM_NAME}\t| ${CMAKE_SYSTEM_NAME}")
    message(STATUS "System Version: ${CMAKE_HOST_SYSTEM_VERSION}\t| ${CMAKE_SYSTEM_VERSION}")
    message(STATUS "System Uinx:    ${CMAKE_HOST_UNIX}")
    message(STATUS "System Windows: ${CMAKE_HOST_WIN32}")
endmacro(system_info)

macro (get_host)
    execute_process( COMMAND /bin/hostname -s
                     OUTPUT_VARIABLE SHOST)
endmacro(get_host)

macro (ReadPkgCfg)
    file (READ tpkg.yml tpkg_content)
    string (REGEX REPLACE "^(.*\n)?name: ([^\n]+).*"            "\\2"  name     ${tpkg_content})
    string (REGEX REPLACE "^(.*\n)?version: ([^\n]+).*"         "\\2"  version  ${tpkg_content})
    string (REGEX REPLACE "^(.*\n)?package_version: ([^\n]+).*" "\\2"  pkg_ver  ${tpkg_content})
    string (REGEX REPLACE "^(.*\n)?source: ([^\n]+).*"          "\\2"  source   ${tpkg_content})
endmacro(ReadPkgCfg)

macro (GetSrcTarPath tarfile tpath)
    if (DEFINED TARBALL_SERVER)
        set(${tpath} "${TARBALL_SERVERS}/${tarfile}" CACHE STRING "Source tar file URL" FORCE)
    else()
        find_file(${tpath} ${tarfile} PATHS ${TARBALLS_DIRS})
    endif()
    show_var(${tpath} 1)
endmacro(GetSrcTarPath)

macro (fCheckMirrors proj url)
    set(mpath "${proj}_pkg")
    get_filename_component(pkg_file ${url} NAME)
    # get_filename_component(pkg_srv ${url} PATH) Doesn't work URLs
    string(REPLACE "/${pkg_file}" "" pkg_srv ${url})
    show_var(pkg_file 1)
    show_var(pkg_srv 1)
    find_file(${mpath} ${pkg_file} PATHS "${DOWNLOAD_DIR}/${proj}" ${TARBALLS_DIRS})
    show_var(${mpath} 1)
    if (NOT ${${mpath}} AND NOT EXISTS ${${mpath}})
        file(MAKE_DIRECTORY "${DOWNLOAD_DIR}/${proj}")
        foreach (srv ${TARBALL_SERVERS} "${pkg_srv}")
            file(DOWNLOAD "${srv}/${pkg_file}"  "${DOWNLOAD_DIR}/${proj}/${pkg_file}"
                 STATUS status
                 SHOW_PROGRESS)
            message("Test ${srv}/${pkg_file}  ${status}")               
            if (${result} EQUAL 0)
                find_file(${mpath} ${pkg_file} PATHS "${DOWNLOAD_DIR}/${proj}")
            endif()
        endforeach()
    endif()
    show_var(${mpath} 1)
endmacro(fCheckMirrors)

macro (CheckMirrors proj url)
    set(mpath "${proj}_pkg")
    get_filename_component(pkg_file ${url} NAME)
    # get_filename_component(pkg_srv ${url} PATH) Doesn't work URLs
    string(REPLACE "/${pkg_file}" "" pkg_srv ${url})
    show_var(pkg_file 1)
    show_var(pkg_srv 1)
    find_file(${mpath} ${pkg_file} PATHS "${DOWNLOAD_DIR}/${proj}" ${TARBALLS_DIRS})
    show_var(${mpath} 1)
    if (NOT ${${mpath}} AND NOT EXISTS ${${mpath}})
        file(MAKE_DIRECTORY "${DOWNLOAD_DIR}/${proj}")
        foreach (srv ${TARBALL_SERVERS} "${pkg_srv}")
            if (${srv} MATCHES ^https.*$)
                message(STATUS "https mode")
                execute_process(COMMAND ${CURL} --fail --progress-bar --insecure "${srv}/${pkg_file}" -o ${pkg_file} 
                                RESULT_VARIABLE result
                                WORKING_DIRECTORY "${DOWNLOAD_DIR}/${proj}")
            else()
                execute_process(COMMAND ${CURL} --fail --progress-bar "${srv}/${pkg_file}" -o ${pkg_file} 
                                RESULT_VARIABLE result
                                WORKING_DIRECTORY "${DOWNLOAD_DIR}/${proj}")
            endif()
            message(STATUS "${CURL} ${srv}/${pkg_file} ${result}")               
            if (${result} EQUAL 0)
                find_file(${mpath} ${pkg_file} PATHS "${DOWNLOAD_DIR}/${proj}")
                break()
            endif()
        endforeach()
    endif()
    show_var(${mpath} 1)
endmacro(CheckMirrors)

