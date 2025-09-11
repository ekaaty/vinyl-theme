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
set(VINYL_PLUGIN_ID_PREFIX "com.ekaaty.vinyl.desktop")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    # We are building standalone
    project(vinyl-looknfeel)
    set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")
    set(SourceFiles
        "${CMAKE_SOURCE_DIR}/cmake"
        "${CMAKE_SOURCE_DIR}/CMakeLists.txt"
        "${CMAKE_SOURCE_DIR}/${VINYL_PLUGIN_ID_PREFIX}.*"
    )

    set(STANDALONE TRUE)
    #set(KDE_INSTALL_LOCALEDIR ${VINYL_PLUGIN_ID_PREFIX}/contents/locale)
    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
    set(STANDALONE FALSE)
    set(KDE_INSTALL_LOCALEDIR ${KDE_INSTALL_DATADIR}/locale)
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS
    Core
    Core5Compat
    Quick
)

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    Config
    CoreAddons
    DocTools
    I18n
)

find_package(Plasma ${PLASMA_MIN_VERSION} REQUIRED)

#add_definitions(-DTRANSLATION_DOMAIN=\"plasma_lookandfeel_${VINYL_PLUGIN_ID_PREFIX}\")
#kdoctools_install(po)
#ki18n_install(po)

execute_process(
    COMMAND sed -i
        "s/\\(.*\"Version\".*\\):.*/\\1: \"${PROJECT_VERSION}\",/g"
        ${CMAKE_CURRENT_SOURCE_DIR}/${VINYL_PLUGIN_ID_PREFIX}.dark/metadata.json
        ${CMAKE_CURRENT_SOURCE_DIR}/${VINYL_PLUGIN_ID_PREFIX}.light/metadata.json
)

if(NOT STANDALONE)
    plasma_install_package(
        ${VINYL_PLUGIN_ID_PREFIX}.dark
        ${VINYL_PLUGIN_ID_PREFIX}.dark
        look-and-feel
        lookandfeel
    )
    plasma_install_package(
        ${VINYL_PLUGIN_ID_PREFIX}.light
        ${VINYL_PLUGIN_ID_PREFIX}.light
        look-and-feel
        lookandfeel
    )
else()
    install(
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${VINYL_PLUGIN_ID_PREFIX}.dark/
        DESTINATION /${VINYL_PLUGIN_ID_PREFIX}.dark
    )
    install(
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${VINYL_PLUGIN_ID_PREFIX}.light/
        DESTINATION /${VINYL_PLUGIN_ID_PREFIX}.light
    )
endif()

# vim: ts=4:sw=4:sts=4:et
