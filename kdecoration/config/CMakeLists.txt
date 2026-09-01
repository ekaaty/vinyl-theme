# @file CMakeLists.txt
# @brief The CMakeLists.txt for Vinyl Kdecoration config.
#
# SPDX-FileCopyrightText: 2026 Christian Tosta
# SPDX-License-Identifier: BSD-3-Clause

file(GLOB_RECURSE UI_FILES "${BREEZE_BUILD_DIR}/kdecoration/*.ui")
foreach(UI_FILE ${UI_FILES})
    file(READ ${UI_FILE} UI_CONTENT)
    string(REPLACE "Breeze::" "${PROJECT_NAMESPACE}::" UI_CONTENT "${UI_CONTENT}")
    string(REPLACE ">Breeze" ">${PROJECT_NAMESPACE}" UI_CONTENT "${UI_CONTENT}")
    file(WRITE ${UI_FILE} "${UI_CONTENT}")
endforeach()

set(breezedecoration_config_SRCS
    ${BREEZE_BUILD_DIR}/kdecoration/breezeexceptionlist.cpp
    ${BREEZE_BUILD_DIR}/kdecoration/config/breezeconfigwidget.cpp
    ${BREEZE_BUILD_DIR}/kdecoration/config/breezedetectwidget.cpp
    ${BREEZE_BUILD_DIR}/kdecoration/config/breezeexceptiondialog.cpp
    ${BREEZE_BUILD_DIR}/kdecoration/config/breezeexceptionlistwidget.cpp
    ${BREEZE_BUILD_DIR}/kdecoration/config/breezeexceptionmodel.cpp
    ${BREEZE_BUILD_DIR}/kdecoration/config/breezeitemmodel.cpp
)
ki18n_wrap_ui(breezedecoration_config_SRCS
   ${BREEZE_BUILD_DIR}/kdecoration/config/ui/breezeconfigurationui.ui
   ${BREEZE_BUILD_DIR}/kdecoration/config/ui/breezeexceptiondialog.ui
   ${BREEZE_BUILD_DIR}/kdecoration/config/ui/breezeexceptionlistwidget.ui
)

kcoreaddons_add_plugin(kcm_${PROJECT_ID}decoration SOURCES
    ${breezedecoration_config_SRCS}
    ${BREEZE_BUILD_DIR}/kdecoration/config/kcm_breezedecoration.cpp
    INSTALL_NAMESPACE "${KDECORATION_KCM_PLUGIN_DIR}"
)

kconfig_add_kcfg_files(kcm_${PROJECT_ID}decoration
    "${BREEZE_BUILD_DIR}/kdecoration/breezesettings.kcfgc"
)

target_include_directories(kcm_${PROJECT_ID}decoration
    PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}
        ${CMAKE_BINARY_DIR}
        ${BREEZE_BUILD_DIR}/kdecoration
        ${BREEZE_BUILD_DIR}/kdecoration/config
)

target_link_libraries(kcm_${PROJECT_ID}decoration
    PUBLIC
        Qt${QT_MAJOR_VERSION}::Core
        Qt${QT_MAJOR_VERSION}::Gui
        Qt${QT_MAJOR_VERSION}::DBus
    PRIVATE
        KF${QT_MAJOR_VERSION}::ConfigCore
        KF${QT_MAJOR_VERSION}::CoreAddons
        KF${QT_MAJOR_VERSION}::GuiAddons
        KF${QT_MAJOR_VERSION}::I18n
        KF${QT_MAJOR_VERSION}::IconThemes
        KF${QT_MAJOR_VERSION}::KCMUtils
)

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/kcm_decoration.cpp.in"
    "${BREEZE_BUILD_DIR}/kdecoration/config/kcm_breezedecoration.cpp"
    @ONLY
)

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/kcm_decoration.json.in"
    "${CMAKE_CURRENT_SOURCE_DIR}/kcm_${PROJECT_ID}decoration.json"
    @ONLY
)

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/kcm_decoration.json.in"
    "${BREEZE_BUILD_DIR}/kdecoration/config/kcm_${PROJECT_ID}decoration.json"
    @ONLY
)

kcmutils_generate_desktop_file(kcm_${PROJECT_ID}decoration)
