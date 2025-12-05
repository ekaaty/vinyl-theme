cmake_minimum_required(VERSION 3.16)

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/.env ENV_FILE)
foreach(VAR ${ENV_FILE})
    string(REGEX MATCH "^[^=]*" KEY ${VAR})
    string(REGEX REPLACE "^[^=]*=" "" VALUE ${VAR})
    if(NOT DEFINED ${KEY})
        set(${KEY} ${VALUE})
    endif()
endforeach()

execute_process(
    COMMAND bash -c
        "date +%y.%1m.%1d -d \"$(git log -n 1 --pretty=format:%cD 2>/dev/null)\""
    OUTPUT_VARIABLE PROJECT_DATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    project(vinyl-colors)
    set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

    set(PACKAGE_INSTALL_DATADIR ${ROOT_DIRECTORY})
    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
    set(PACKAGE_INSTALL_DATADIR ${KDE_INSTALL_DATADIR}/color-schemes)
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)

install(
    DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/
    DESTINATION ${PACKAGE_INSTALL_DATADIR}/
)
