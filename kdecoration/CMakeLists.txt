# @file CMakeLists.txt
# @brief The CMakeLists.txt for Vinyl Kdecoration.
#
# SPDX-FileCopyrightText: 2026 Christian Tosta
# SPDX-License-Identifier: BSD-3-Clause

set(BREEZE_BUILD_DIR ${CMAKE_BINARY_DIR}/kdecoration/breeze)
file(REMOVE_RECURSE ${BREEZE_BUILD_DIR})
file(COPY ${BREEZE_SOURCE_DIR}/ DESTINATION ${BREEZE_BUILD_DIR})

string(REGEX REPLACE "[^a-zA-Z0-9]" "" PROJECT_NAMESPACE "${PROJECT_NAME}")
if(PROJECT_NAMESPACE MATCHES "^[0-9]")
    set(PROJECT_NAMESPACE "V${PROJECT_NAMESPACE}")
endif()

string(TOLOWER "${PROJECT_NAMESPACE}" PROJECT_ID)

add_definitions(-DTRANSLATION_DOMAIN="breeze_kwin_deco")

execute_process(
    COMMAND patch
        --forward --batch
        -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patches/breeze-6.6.80-parametrization.patch
    WORKING_DIRECTORY ${BREEZE_BUILD_DIR}
    RESULT_VARIABLE PATCH_RESULT
)

if(NOT PATCH_RESULT EQUAL 0)
    message(FATAL_ERROR "Fail to apply parametrization patch to Breeze.")
endif()

configure_file(config.h.in ${BREEZE_BUILD_DIR}/kdecoration/config.h @ONLY)
configure_file(settings.kcfgc.in ${BREEZE_BUILD_DIR}/kdecoration/breezesettings.kcfgc @ONLY)
configure_file(settingsdata.kcfg.in ${BREEZE_BUILD_DIR}/kdecoration/breezesettingsdata.kcfg @ONLY)
configure_file(kwindecoration.json.in ${BREEZE_BUILD_DIR}/kdecoration/${PROJECT_ID}.json @ONLY)

find_package(Qt${QT_MAJOR_VERSION} ${QT${QT_MAJOR_VERSION}_MIN_VERSION} REQUIRED COMPONENTS
    Core
    DBus
    Gui
)

find_package(KF${QT_MAJOR_VERSION} ${KF${QT_MAJOR_VERSION}_MIN_VERSION} REQUIRED COMPONENTS
    ColorScheme
    CoreAddons
    GuiAddons
    I18n
    IconThemes
    KCMUtils
)

include_directories(
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_BINARY_DIR}"
    "${BREEZE_BUILD_DIR}/libbreezecommon"
    "${BREEZE_BUILD_DIR}/kdecoration"
    "${CMAKE_SOURCE_DIR}/common"
)

set(breezedecoration_SRCS
    "${BREEZE_BUILD_DIR}/kdecoration/breezebutton.cpp"
    "${BREEZE_BUILD_DIR}/kdecoration/breezedecoration.cpp"
    "${BREEZE_BUILD_DIR}/kdecoration/breezesettingsprovider.cpp"
    "${BREEZE_BUILD_DIR}/kdecoration/breezeexceptionlist.cpp"
)

set(${PROJECT_ID}decoration_SRCS
    "${breezedecoration_SRCS}"
)

kconfig_add_kcfg_files(${PROJECT_ID}decoration_SRCS
    "${BREEZE_BUILD_DIR}/kdecoration/breezesettings.kcfgc"
)

add_library(${PROJECT_ID}decoration MODULE
    "${${PROJECT_ID}decoration_SRCS}"
    "${${PROJECT_ID}decoration_config_PART_FORMS_HEADERS}"
    "${CMAKE_CURRENT_SOURCE_DIR}/config/kcm_${PROJECT_ID}decoration.json"
)

set_target_properties(${PROJECT_ID}decoration PROPERTIES
    OUTPUT_NAME org.kde.kwin.${PROJECT_ID}
)

find_package(KDecoration3 REQUIRED)

target_link_libraries(${PROJECT_ID}decoration
    PRIVATE
        ${KDECORATION}
        KF${QT_MAJOR_VERSION}::ColorScheme
        KF${QT_MAJOR_VERSION}::ConfigGui
        KF${QT_MAJOR_VERSION}::CoreAddons
        KF${QT_MAJOR_VERSION}::GuiAddons
        KF${QT_MAJOR_VERSION}::I18n
        KF${QT_MAJOR_VERSION}::IconThemes
        Qt${QT_MAJOR_VERSION}::DBus
        ${PROJECT_ID}::common
)

target_include_directories(${PROJECT_ID}decoration
    PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
    ${BREEZE_BUILD_DIR}/kdecoration
)

install(
    TARGETS ${PROJECT_ID}decoration
    DESTINATION "${KDE_INSTALL_PLUGINDIR}/${KDECORATION_PLUGIN_DIR}"
)

add_subdirectory(config)
