
set(paraview_name    "paraview_release")
set(paraview_version "3.10.1")
set(paraview_proj    "${paraview_name}-${paraview_version}")
set(paraview_prefix  "${CMAKE_INSTALL_PREFIX}/pv-${paraview_version}")
set(paraview_git     "git://paraview.org/ParaView.git")

ExternalProject_Add(${paraview_proj}
  GIT_REPOSITORY ${paraview_git}
  GIT_TAG release
  INSTALL_DIR ${paraview_prefix} 
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
             -DCMAKE_BUILD_TYPE=Debug
             -DCMAKE_VERBOSE_MAKEFILE=OFF
             -DCMAKE_INSTALL_RPATH:PATH="${PYTHON_LIBRARY_DIR}:${paraview_prefix}/lib:${paraview_prefix}/lib/paraview-${paraview_version}"
             -DBUILD_SHARED_LIBS=ON
             -DPARAVIEW_ENABLE_PYTHON=ON
             -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE}
             -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
             -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY}
             -DPARAVIEW_BUILD_QT_GUI=OFF
             -DPARAVIEW_INSTALL_DEVELOPMENT=ON
  BUILD_COMMAND ${build_cmd_smp}
  #DEPENDS
)

ExternalProject_Get_Property(${paraview_proj} source_dir binary_dir install_dir)

set(PV_RELEASE ${proj} PARENT_SCOPE)
set(PV_RELEASE_HOME ${install_dir} PARENT_SCOPE)
set(PV_RELEASE_LIB ${install_dir}/lib/paraview-${paraview_version} PARENT_SCOPE)

ExternalProject_Add_Step(${paraview_proj} "install-hfile"
    COMMAND ${CMAKE_COMMAND} -E copy "${source_dir}/Utilities/VTKPythonWrapping/Executable/vtkPVPythonInterpretor.h"
                                     "${install_dir}/lib/paraview-${paraview_version}/"
    DEPENDEES install
)