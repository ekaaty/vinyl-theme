cmake_minimum_required(VERSION 3.16)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    project(vinyl-konsole)
    string(TIMESTAMP PROJECT_VERSION "%Y%m%d")

    set(PACKAGE_INSTALL_DATADIR ${ROOT_DIRECTORY})
    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
    set(PACKAGE_INSTALL_DATADIR ${KDE_INSTALL_DATADIR})
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)
include(KDEInstallDirs6)

install(FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/Vinyl-Dark.colorscheme
        ${CMAKE_CURRENT_SOURCE_DIR}/src/Vinyl-Light.colorscheme
    DESTINATION ${PACKAGE_INSTALL_DATADIR}/konsole/
)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/Vinyl.profile
    DESTINATION ${PACKAGE_INSTALL_DATADIR}/konsole/
)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/profile.d/
    DESTINATION ${PACKAGE_INSTALL_DATADIR}/konsole/profile.d/
)
