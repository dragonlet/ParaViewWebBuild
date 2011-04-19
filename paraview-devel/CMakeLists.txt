
set(paraview_name    "paraview_devel")
set(paraview_version "3.11")
set(paraview_proj    "${paraview_name}-${paraview_version}")
set(paraview_prefix  "${CMAKE_INSTALL_PREFIX}/pv-${paraview_version}")
set(paraview_git     "git://paraview.org/ParaView.git")

ExternalProject_Add(${paraview_proj}
  GIT_REPOSITORY ${paraview_git}
  GIT_TAG master
  INSTALL_DIR ${paraview_prefix} 
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
             -DCMAKE_BUILD_TYPE=Debug
             -DCMAKE_VERBOSE_MAKEFILE=OFF
             -DBUILD_SHARED_LIBS=ON
             -DPARAVIEW_ENABLE_PYTHON=ON
             -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}
             -DPYTHON_INCLUDE_DIR=/home/kirk/tools/python2.6/include/python2.6
             -DPYTHON_LIBRARY=/home/kirk/tools/python2.6/lib/libpython2.6.so
             -DPARAVIEW_BUILD_QT_GUI=OFF
             -DPARAVIEW_INSTALL_DEVELOPMENT=ON
  BUILD_COMMAND ${build_cmd_smp}
  #DEPENDS
)

ExternalProject_Get_Property(${paraview_proj} source_dir binary_dir install_dir)

set(PV_DEVEL ${paraview_proj} PARENT_SCOPE)
set(PV_DEVEL_HOME ${install_dir} PARENT_SCOPE)
set(PV_DEVEL_LIB ${install_dir}/lib/paraview-${paraview_version} PARENT_SCOPE)

ExternalProject_Add_Step(${paraview_proj} "install-hfile"
    COMMAND ${CMAKE_COMMAND} -E copy "${source_dir}/Utilities/VTKPythonWrapping/Executable/vtkPVPythonInterpretor.h"
                                     "${install_dir}/include/paraview-${paraview_version}/"
    DEPENDEES install
)

set(paraview_mesa_name    "paraview_mesa")
set(paraview_mesa_version "3.11")
set(paraview_mesa_proj    "${paraview_mesa_name}-${paraview_mesa_version}")
set(paraview_mesa_prefix  "${CMAKE_INSTALL_PREFIX}/pv_mesa-${paraview_version}")
set(paraview_mesa_git     "git://paraview.org/ParaView.git")

set(mesa_name    "mesa")
set(mesa_version "7.7.1")
set(mesa_proj    "${mesa_name}-${mesa_version}")
set(mesa_prefix  "${paraview_mesa_prefix}")
set(mesa_url     "ftp://ftp.freedesktop.org/pub/mesa/${mesa_version}/MesaLib-${mesa_version}.tar.bz2")
CheckMirrors(${mesa_proj} ${mesa_url})

ExternalProject_Add(${mesa_proj}
  URL ${${mesa_proj}_pkg}
  INSTALL_DIR ${mesa_prefix}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --with-driver=xlib
                    --disable-egl
                    --disable-gallium
                    "LDFLAGS=-Wl,-rpath -Wl,${mesa_prefix}/lib"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND ${build_cmd_smp}
  #DEPENDS
)

ExternalProject_Add(${paraview_mesa_proj}
  GIT_REPOSITORY ${paraview_mesa_git}
  GIT_TAG master
  INSTALL_DIR ${paraview_mesa_prefix}
  LIST_SEPARATOR ::
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
             -DCMAKE_BUILD_TYPE=Debug
             -DCMAKE_VERBOSE_MAKEFILE=OFF
             -DCMAKE_INSTALL_RPATH:PATH=${PYTHON_LIBRARY_DIR}::${paraview_mesa_prefix}/lib::${paraview_mesa_prefix}/lib/paraview-${paraview_mesa_version}
             -DBUILD_SHARED_LIBS=ON
             -DPARAVIEW_ENABLE_PYTHON=ON
             -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE}
             -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
             -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY}
             -DPARAVIEW_BUILD_QT_GUI=OFF
             -DPARAVIEW_INSTALL_DEVELOPMENT=ON 
             -DVTK_USE_MANGLED_MESA=OFF
             -DVTK_USE_DISPLAY=OFF
             -DVTK_OPENGL_HAS_OSMESA=ON
             -DVTK_USE_OFFSCREEN=ON
             -DOPENGL_INCLUDE_DIR:PATH=${mesa_prefix}/include
             -DOPENGL_xmesa_INCLUDE_DIR:PATH=${mesa_prefix}/include
             -DOPENGL_gl_LIBRARY:FILEPATH=${mesa_prefix}/lib/libGL.so
             -DOPENGL_glu_LIBRARY:FILEPATH=${mesa_prefix}/lib/libGLU.so
             -DOSMESA_INCLUDE_DIR:PATH=${mesa_prefix}/include
             -DOSMESA_LIBRARY:FILEPATH=${mesa_prefix}/lib/libOSMesa.so
  BUILD_COMMAND ${build_cmd_smp}
  DEPENDS ${mesa_proj}
)

ExternalProject_Get_Property(${paraview_mesa_proj} source_dir binary_dir install_dir)

ExternalProject_Add_Step(${paraview_mesa_proj} "install-hfile"
    COMMAND ${CMAKE_COMMAND} -E copy "${source_dir}/Utilities/VTKPythonWrapping/Executable/vtkPVPythonInterpretor.h"
                                     "${install_dir}/include/paraview-${paraview_version}/"
    DEPENDEES install
)

set(PV_MESA ${paraview_mesa_proj} PARENT_SCOPE)
set(PV_MESA_HOME ${install_dir} PARENT_SCOPE)
set(PV_MESA_LIB ${install_dir}/lib/paraview_mesa-${paraview_mesa_version} PARENT_SCOPE)

