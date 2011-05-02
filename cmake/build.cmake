
# Parallel Building
file(STRINGS "/proc/cpuinfo" procs REGEX "^processor.: [0-9]+$")
list(LENGTH procs PROCESSOR_COUNT)

set(BUILD_SMP "${PROCESSOR_COUNT}" CACHE STRING "Parallel Build")
find_program(MAKE_COMMAND NAMES make)
if( ${BUILD_SMP} LESS 2 )
    set(BUILD_CMD_SMP  ${MAKE_COMMAND})
else()
    set(BUILD_CMD_SMP  ${MAKE_COMMAND} "-j${BUILD_SMP}" "-l${BUILD_SMP}")
endif()
set(BUILD_CMD          ${MAKE_COMMAND})
set(INSTALL_CMD        ${MAKE_COMMAND})
