cmake_minimum_required(VERSION 3.16)
set(VINYL_SPLASH_PLUGIN_ID "com.ekaaty.vinyl-splash")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    # We are building standalone
    project(vinyl-splash)
    string(TIMESTAMP PROJECT_VERSION "%Y%m%d")
    set(SourceFiles
        "${CMAKE_SOURCE_DIR}/cmake"
        "${CMAKE_SOURCE_DIR}/CMakeLists.txt"
        "${CMAKE_SOURCE_DIR}/po"
        "${CMAKE_SOURCE_DIR}/src/package"
    )

    set(KDE_COMPILERSETTINGS_LEVEL "5.82")
    set(KF6_MIN_VERSION "6.14.0")
    set(PLASMA_MIN_VERSION "6.4.0")
    set(QT_MIN_VERSION "6.8.0")

    set(PACKAGE_INSTALL_DATADIR ${VINYL_SPLASH_PLUGIN_ID})
    set(KDE_INSTALL_LOCALEDIR ${VINYL_SPLASH_PLUGIN_ID}/contents/locale)
    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
    set(PACKAGE_INSTALL_DATADIR ${KDE_INSTALL_DATADIR}/plasma/look-and-feel)
    set(KDE_INSTALL_LOCALEDIR ${CMAKE_INSTALL_PREFIX}/share/locale)
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

add_definitions(-DTRANSLATION_DOMAIN=\"plasma_lookandfeel_${VINYL_SPLASH_PLUGIN_ID}\")
kdoctools_install(po)
ki18n_install(po)

install(
    DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/package/contents
    DESTINATION ${PACKAGE_INSTALL_DATADIR}
)

# vim: ts=2:sw=2:sts=2:et
