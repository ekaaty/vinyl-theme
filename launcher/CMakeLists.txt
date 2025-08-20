cmake_minimum_required(VERSION 3.16)

execute_process(
    COMMAND bash -c
        "date +%y.%1m.%1d -d \"$(git log -n 1 --pretty=format:%cD 2>/dev/null)\""
    OUTPUT_VARIABLE PROJECT_DATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(PLASMA_VERSION "6.4.4")
set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")
set(VINYL_LAUNCHER_PLUGIN_ID "com.ekaaty.vinyl-launcher")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    # We are building standalone
    project(vinyl-launcher)
    set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")
    set(SourceFiles
        "${CMAKE_SOURCE_DIR}/cmake"
        "${CMAKE_SOURCE_DIR}/CMakeLists.txt"
        "${CMAKE_SOURCE_DIR}/po"
        "${CMAKE_SOURCE_DIR}/src/package"
    )

    set(KDE_COMPILERSETTINGS_LEVEL "5.82")
    set(KF6_MIN_VERSION "6.13.0")
    set(PLASMA_MIN_VERSION "6.3.0")
    set(QT_MIN_VERSION "6.8.0")

    set(STANDALONE TRUE)
    set(KDE_INSTALL_LOCALEDIR ${VINYL_LAUNCHER_PLUGIN_ID}/contents/locale)
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

add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_${VINYL_LAUNCHER_PLUGIN_ID}\")
kdoctools_install(po)
ki18n_install(po)

execute_process(
    COMMAND sed -i
        "s/\\(.*\"Version\".*\\):.*/\\1: \"${PROJECT_VERSION}\",/g"
        ${CMAKE_CURRENT_SOURCE_DIR}/src/package/metadata.json
)

if(NOT STANDALONE)
    plasma_install_package(
        src/package 
        ${VINYL_LAUNCHER_PLUGIN_ID} 
    )
else()
    install(
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/package/
        DESTINATION /${VINYL_LAUNCHER_PLUGIN_ID}
    )
endif()

# vim: ts=4:sw=4:sts=4:et
