
set(pwsource_name    "PWSource")
set(pwsource_version "git")
set(pwsource_proj    "${pwsource_name}-${pwsource_version}")
set(pwsource_prefix  "${CMAKE_INSTALL_PREFIX}/${pwsource_name}")
set(pwsource_git     "git://paraview.org/ParaViewWeb.git")
#set(pwsource_git     "git://hsai-dev/code/ParaViewWeb.git")

ExternalProject_Add(${pwsource_proj}
  GIT_REPOSITORY ${pwsource_git}
  #GIT_TAG master
  GIT_TAG pv-3.10.1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)

ExternalProject_Get_Property(${pwsource_proj} source_dir)

set(PWSOURCE       ${pwsource_proj}    PARENT_SCOPE)
set(PWSOURCE_VER   ${pwsource_version} PARENT_SCOPE)
set(PWSOURCE_HOME  ${source_dir}       PARENT_SCOPE)

