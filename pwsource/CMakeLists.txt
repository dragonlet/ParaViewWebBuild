
set(pwsource_name    "PWSource")

if (PVWEB_GIT)
    set(pwsource_version "git")
    set(pwsource_proj    "${pwsource_name}-${pwsource_version}")
    set(pwsource_prefix  "${CMAKE_INSTALL_PREFIX}/${pwsource_name}")
    set(pwsource_git     "http://paraview.org/ParaViewWeb.git")
    #set(pwsource_git     "git://hsai-dev/code/ParaViewWeb.git")
    
    ExternalProject_Add(${pwsource_proj}
      GIT_REPOSITORY ${pwsource_git}
      GIT_TAG master
      #GIT_TAG pv-3.10.1
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
    )
else (PVWEB_GIT)
    #set(pwsource_version "pv-3.10.1")
    set(pwsource_version "20120412")
    set(pwsource_proj    "${pwsource_name}-${pwsource_version}")
    set(pwsource_prefix  "${CMAKE_INSTALL_PREFIX}/${pwsource_name}")
    set(pwsource_url     "http://github.com/ktkirk/tarballs/raw/master/ParaViewWeb-${pwsource_version}.tar.bz2")
    CheckMirrors(${pwsource_proj} ${pwsource_url})
    
    ExternalProject_Add(${pwsource_proj}
      URL ${${pwsource_proj}_pkg}
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
    )
endif (PVWEB_GIT)

ExternalProject_Get_Property(${pwsource_proj} source_dir)

set(PWSOURCE       ${pwsource_proj}    PARENT_SCOPE)
set(PWSOURCE_VER   ${pwsource_version} PARENT_SCOPE)
set(PWSOURCE_HOME  ${source_dir}       PARENT_SCOPE)

