
set(manta_src_name    "manta_src")
set(manta_src_version "svn")
set(manta_src_proj    "${manta_src_name}-${manta_src_version}")
set(manta_src_svn     "https://gforge.sci.utah.edu/svn/Manta/trunk")
set(manta_src_url     "${manta_src_proj}-r2507.tar.bz2")
CheckMirrors(${manta_src_proj} ${manta_src_url})

ExternalProject_Add(${manta_src_proj}
  #SVN_REPOSITORY ${manta_src_svn}
  #SVN_REVISION 
  URL ${${manta_src_proj}_pkg}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)

ExternalProject_Get_Property(${manta_src_proj} source_dir)

set(MANTA_SRC       ${manta_src_proj}    PARENT_SCOPE)
set(MANTA_SRC_VER   ${manta_src_version} PARENT_SCOPE)
set(MANTA_SOURCE    ${source_dir}        PARENT_SCOPE)
set(manta_src_dir   ${source_dir})

set(manta_name    "manta")
set(manta_version "svn")
set(manta_proj    "${manta_name}-${manta_version}")
set(manta_prefix  "${CMAKE_INSTALL_PREFIX}/${manta_proj}")

ExternalProject_Add(${manta_proj}
  DOWNLOAD_COMMAND ""
  SOURCE_DIR  ${manta_src_dir}
  INSTALL_DIR ${manta_prefix} 
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
             -DCMAKE_BUILD_TYPE=Debug
             -DCMAKE_VERBOSE_MAKEFILE=OFF
             -DCMAKE_INSTALL_RPATH:PATH=${manta_prefix}/lib
             -DBUILD_SHARED_LIBS=ON
  BUILD_COMMAND ${BUILD_CMD_SMP}
  INSTALL_COMMAND ""
  DEPENDS ${manta_src_proj}
)

ExternalProject_Get_Property(${manta_proj} source_dir binary_dir install_dir)

set(MANTA       ${manta_proj}       PARENT_SCOPE)
set(MANTA_HOME  ${install_dir}      PARENT_SCOPE)
set(MANTA_BUILD ${binary_dir}       PARENT_SCOPE)
set(MANTA_LIB   ${install_dir}/lib  PARENT_SCOPE)

ExternalProject_Add_Step(${manta_proj} "install-manta"
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${binary_dir}/bin ${install_dir}/bin
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${binary_dir}/lib ${install_dir}/lib
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${binary_dir}/include ${install_dir}/include
    DEPENDEES install
)
