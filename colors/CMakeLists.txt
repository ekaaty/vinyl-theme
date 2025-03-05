cmake_minimum_required(VERSION 3.16)

if( CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR )
project(vinyl-colors)
else()
# We are building as part of Main project
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH}  ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)
include(KDEInstallDirs6)

install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/
    DESTINATION ${KDE_INSTALL_DATADIR}/color-schemes/
)
