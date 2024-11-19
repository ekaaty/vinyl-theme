cmake_minimum_required(VERSION 3.16)

if( CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR )
project(vinyl-icons)
else()
# We are building as part of Main project
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH}  ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)
include(KDEInstallDirs6)

add_custom_command( OUTPUT
    ${CMAKE_CURRENT_SOURCE_DIR}/build/Vinyl
    COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/make-theme.sh
)

add_custom_target( themes
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/build/Vinyl
)

add_custom_target( clean-themes
    COMMAND rm -rf ${CMAKE_CURRENT_SOURCE_DIR}/build/Vinyl
)

add_custom_target(clean-all
    DEPENDS clean-themes
    COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR} && grep -vE '^build/' .gitignore | xargs -n1 rm -rf && cd - >/dev/null 2>&1
)

install( DIRECTORY build/Vinyl/
    DESTINATION ${KDE_INSTALL_DATADIR}/icons/Vinyl/
)
