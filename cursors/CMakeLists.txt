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
    project(vinyl-cursors)
    set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

    set(PACKAGE_INSTALL_DATADIR ${ROOT_DIRECTORY})
    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
    set(PACKAGE_INSTALL_DATADIR ${KDE_INSTALL_DATADIR}/icons)
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)

add_custom_command(COMMAND
        make -C ${CMAKE_CURRENT_SOURCE_DIR} -f Render.make -j1
    OUTPUT
        ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-Black
        ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-White
)

add_custom_target(cursor-themes ALL
        make -C ${CMAKE_CURRENT_SOURCE_DIR} -f Render.make -j1 black white clean
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-Black
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-White
)

install( DIRECTORY build/Vinyl-Black/
    DESTINATION ${PACKAGE_INSTALL_DATADIR}/Vinyl-Black/
)

install( DIRECTORY build/Vinyl-White/
    DESTINATION ${PACKAGE_INSTALL_DATADIR}/Vinyl-White/
)
