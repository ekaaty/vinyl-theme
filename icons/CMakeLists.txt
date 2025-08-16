cmake_minimum_required(VERSION 3.16)

execute_process(
    COMMAND bash -c
        "date +%y.%1m.%1d -d \"$(git log -n 1 --pretty=format:%cD 2>/dev/null)\""
    OUTPUT_VARIABLE PROJECT_DATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(PLASMA_VERSION "6.4.4")
set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    project(vinyl-icons)
    set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

    set(PACKAGE_INSTALL_DATADIR ${ROOT_DIRECTORY})
    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
    set(PACKAGE_INSTALL_DATADIR ${KDE_INSTALL_DATADIR}/icons)
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH}  ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)
include(KDEInstallDirs6)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/build/Vinyl
    COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/make-theme.sh
)

add_custom_target(icon-themes ALL
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/build/Vinyl
)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/build/Vinyl/
    DESTINATION ${PACKAGE_INSTALL_DATADIR}/Vinyl/
)
