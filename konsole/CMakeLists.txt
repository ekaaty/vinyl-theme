cmake_minimum_required(VERSION 3.16)

execute_process(
    COMMAND bash -c
        "date +%y.%1m.%1d -d \"$(git log -n 1 --pretty=format:%cD 2>/dev/null)\""
    OUTPUT_VARIABLE PROJECT_DATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(PLASMA_VERSION "6.4.3")
set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    project(vinyl-konsole)
    set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

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
