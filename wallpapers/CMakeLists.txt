cmake_minimum_required(VERSION 3.16)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    project(vinyl-wallpapers)
    string(TIMESTAMP PROJECT_VERSION "%Y%m%d")

    set(PACKAGE_INSTALL_DATADIR ${ROOT_DIRECTORY})
    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
    set(PACKAGE_INSTALL_DATADIR ${KDE_INSTALL_DATADIR}/wallpapers)
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)
include(KDEInstallDirs6)

if(BUILD_STANDALONE)
install(DIRECTORY Vinyl-Tracks/
    DESTINATION ./Vinyl-Tracks/
)
else()
install(DIRECTORY Vinyl-Tracks/
    DESTINATION ${PACKAGE_INSTALL_DATADIR}/Vinyl-Tracks/
)
endif()
