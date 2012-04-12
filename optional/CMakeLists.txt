# Optional
# Packages
#

set(flex_sdk_name    "flex_sdk")
set(flex_sdk_version "3.4.0.9271_mpl")
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
set(FLEX_SDK        ${flex_sdk_proj}   PARENT_SCOPE)
set(FLEX_SDK_PREFIX ${flex_sdk_prefix} PARENT_SCOPE)

set(gwt_name    "gwt")
set(gwt_version "2.0.3")
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
set(GWT        ${gwt_proj}   PARENT_SCOPE)
set(GWT_PREFIX ${gwt_prefix} PARENT_SCOPE)

set(qooxdoo_name    "qooxdoo")
set(qooxdoo_version "1.5")
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
set(QOOXDOO        ${qooxdoo_proj}   PARENT_SCOPE)
set(QOOXDOO_PREFIX ${qooxdoo_prefix} PARENT_SCOPE)


