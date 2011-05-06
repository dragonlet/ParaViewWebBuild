
set(paraview_src_name    "paraview_src")
set(paraview_src_version "3.10.1")
set(paraview_src_proj    "${paraview_src_name}-${paraview_src_version}")
set(paraview_src_git     "git://paraview.org/ParaView.git")
set(paraview_src_url     "http://paraview.org/files/v3.10/ParaView-${paraview_src_version}.tar.gz")
CheckMirrors(${paraview_src_proj} ${paraview_src_url})

ExternalProject_Add(${paraview_src_proj}
  #GIT_REPOSITORY ${paraview_src_git}
  #GIT_TAG "v${paraview_src_version}"
  URL ${${paraview_src_proj}_pkg}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)

ExternalProject_Get_Property(${paraview_src_proj} source_dir)

set(PV_SRC_REL       ${paraview_src_proj}    PARENT_SCOPE)
set(PV_SRC_REL_VER   ${paraview_src_version} PARENT_SCOPE)
set(PV_SRC_REL_HOME  ${source_dir}           PARENT_SCOPE)
set(pv_src_rel_dir   ${source_dir})

message(STATUS "Pavaview source: ${pv_src_rel_dir}")

if (NOT PV_OSMESA)

    set(paraview_name    "paraview")
    set(paraview_version "3.10")
    set(paraview_proj    "${paraview_name}-${paraview_src_version}")
    set(paraview_prefix  "${CMAKE_INSTALL_PREFIX}/pv-${paraview_version}")
    
    ExternalProject_Add(${paraview_proj}
      DOWNLOAD_COMMAND ""
      SOURCE_DIR  ${pv_src_rel_dir}
      INSTALL_DIR ${paraview_prefix} 
      CMAKE_GENERATOR "${CMAKE_GENERATOR}"
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                 -DCMAKE_BUILD_TYPE=Debug
                 -DCMAKE_VERBOSE_MAKEFILE=OFF
                 -DCMAKE_INSTALL_RPATH:PATH=${PYTHON_LIBRARY_DIR}::${paraview_prefix}/lib/paraview-${paraview_version}::${MANTA_LIB}
                 -DBUILD_SHARED_LIBS=ON
                 -DPARAVIEW_ENABLE_PYTHON=ON
                 -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}
                 -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_DIR}
                 -DPYTHON_LIBRARY=${PYTHON_LIBRARY}
                 -DPARAVIEW_BUILD_QT_GUI=OFF
                 -DPARAVIEW_INSTALL_DEVELOPMENT=ON
                 -DPARAVIEW_BUILD_PLUGIN_Manta=ON
                 -DMANTA_BUILD:PATH=${MANTA_BUILD}
                 -DMANTA_SOURCE:PATH=${MANTA_SOURCE}
      BUILD_COMMAND ${BUILD_CMD_SMP}
      DEPENDS ${paraview_src_proj} ${MANTA}
    )
    
    ExternalProject_Get_Property(${paraview_proj} source_dir binary_dir install_dir)
    
    set(PV_RELEASE      ${paraview_proj} PARENT_SCOPE)
    set(PV_RELEASE_HOME ${install_dir}   PARENT_SCOPE)
    set(PV_RELEASE_LIB  ${install_dir}/lib/paraview-${paraview_version} PARENT_SCOPE)
    set(ParaView_DIR  ${install_dir}/lib/paraview-${paraview_version}   PARENT_SCOPE)
    
    ExternalProject_Add_Step(${paraview_proj} "install-hfile"
        COMMAND ${CMAKE_COMMAND} -E copy "${source_dir}/Utilities/VTKPythonWrapping/Executable/vtkPVPythonInterpretor.h"
                                         "${install_dir}/include/paraview-${paraview_version}/"
        DEPENDEES install
    )

else (NOT PV_OSMESA)

    set(paraview_mesa_name    "paraview_mesa")
    set(paraview_mesa_version "3.10")
    set(paraview_mesa_proj    "${paraview_mesa_name}-${paraview_mesa_version}")
    set(paraview_mesa_prefix  "${CMAKE_INSTALL_PREFIX}/pv_mesa-${paraview_src_version}")
  
    if (SYSTEM_MESA)
      # Use System Mesa
      ExternalProject_Add(${paraview_mesa_proj}
        DOWNLOAD_COMMAND ""
        SOURCE_DIR  ${pv_src_rel_dir}
        INSTALL_DIR ${paraview_mesa_prefix}
        LIST_SEPARATOR ::
        CMAKE_GENERATOR "${CMAKE_GENERATOR}"
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                   -DCMAKE_BUILD_TYPE=Debug
                   -DCMAKE_VERBOSE_MAKEFILE=OFF
                   -DCMAKE_INSTALL_RPATH:PATH=${PYTHON_LIBRARY_DIR}::${paraview_mesa_prefix}/lib/paraview-${paraview_mesa_version}
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
        BUILD_COMMAND ${BUILD_CMD_SMP}
        DEPENDS ${paraview_src_proj}
    )
    else (SYSTEM_MESA)
      # Build Mesa
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
        BUILD_COMMAND ${BUILD_CMD_SMP}
        #DEPENDS
      )
    
    ExternalProject_Add(${paraview_mesa_proj}
      DOWNLOAD_COMMAND ""
      SOURCE_DIR  ${pv_src_rel_dir}
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
      BUILD_COMMAND ${BUILD_CMD_SMP}
      DEPENDS ${mesa_proj} ${paraview_src_proj}
    )
    endif (SYSTEM_MESA)
    ExternalProject_Get_Property(${paraview_mesa_proj} source_dir binary_dir install_dir)
    
    ExternalProject_Add_Step(${paraview_mesa_proj} "install-hfile"
        COMMAND ${CMAKE_COMMAND} -E copy "${source_dir}/Utilities/VTKPythonWrapping/Executable/vtkPVPythonInterpretor.h"
                                         "${install_dir}/include/paraview-${paraview_mesa_version}/"
        DEPENDEES install
    )
    
    set(PV_REL_MESA      ${paraview_mesa_proj} PARENT_SCOPE)
    set(PV_REL_MESA_HOME ${install_dir}        PARENT_SCOPE)
    set(PV_REL_MESA_LIB  ${install_dir}/lib/paraview-${paraview_mesa_version} PARENT_SCOPE)
    set(ParaView_DIR     ${install_dir}/lib/paraview-${paraview_mesa_version}      PARENT_SCOPE)
endif (NOT PV_OSMESA)