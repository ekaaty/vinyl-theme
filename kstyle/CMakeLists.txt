# @file CMakeLists.txt
# @brief The CMakeLists.txt for Vinyl Kstyle.
#
# SPDX-FileCopyrightText: 2026 Christian Tosta
# SPDX-License-Identifier: BSD-3-Clause

find_package(Qt${QT_MAJOR_VERSION} ${QT${QT_MAJOR_VERSION}_MIN_VERSION} REQUIRED COMPONENTS
    Core
    DBus
    Gui
    Widgets
)

find_package(KF${QT_MAJOR_VERSION} ${KF${QT_MAJOR_VERSION}_MIN_VERSION} REQUIRED COMPONENTS
    Config
    ConfigWidgets
    GuiAddons
    I18n
    IconThemes
    WindowSystem
)

include_directories(
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_BINARY_DIR}"
    "${BREEZE_SOURCE_DIR}/libbreezecommon"
    "${BREEZE_SOURCE_DIR}/kstyle"
    "${BREEZE_SOURCE_DIR}/kstyle/animations"
    "${BREEZE_SOURCE_DIR}/kstyle/debug"
    "${CMAKE_CURRENT_SOURCE_DIR}/animations"
    "${CMAKE_CURRENT_SOURCE_DIR}/debug"
)

configure_file(
    "${BREEZE_SOURCE_DIR}/kstyle/config-breeze.h.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/config-breeze.h"
)

#configure_file(
#    "config-vinyl.h.cmake"
#    "${CMAKE_CURRENT_BINARY_DIR}/config-vinyl.h"
#)

set(breeze_appstyle_SRCS
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezeanimation.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezeanimations.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezeanimationdata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezebaseengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezebusyindicatordata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezebusyindicatorengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezedialdata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezedialengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezeenabledata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezegenericdata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezeheaderviewdata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezeheaderviewengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezescrollbardata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezescrollbarengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezespinboxengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezespinboxdata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezestackedwidgetdata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezestackedwidgetengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezetabbarengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezetabbardata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezetoolboxengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezetransitiondata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezetransitionwidget.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezewidgetstateengine.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/animations/breezewidgetstatedata.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/debug/breezewidgetexplorer.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezeaddeventfilter.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezeblurhelper.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezeframeshadow.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezehelper.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezemdiwindowshadow.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezemnemonics.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezepropertynames.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezeshadowhelper.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezesplitterproxy.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezestyle.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezetileset.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezewindowmanager.cpp"
    "${BREEZE_SOURCE_DIR}/kstyle/breezetoolsareamanager.cpp"
)

set(vinyl_appstyle_SRCS
    "${breeze_appstyle_SRCS}"
    "elements/vinylbuttonprimitive.cpp"
    "elements/vinylbuttoncontrol.cpp"
    "elements/vinylcomboboxprimitive.cpp"
    "elements/vinylcomboboxcontrol.cpp"
    "elements/vinylcomboboxcomplex.cpp"
    "elements/vinylframeprimitive.cpp"
    "elements/vinyldolphinurlnavigator.cpp"
    "vinylhelper.cpp"
    "vinylstyle.cpp"
    "vinylstyleplugin.cpp"
)

kconfig_add_kcfg_files(vinyl_appstyle_SRCS "${BREEZE_SOURCE_DIR}/kdecoration/breezesettings.kcfgc")
kconfig_add_kcfg_files(vinyl_appstyle_SRCS "${BREEZE_SOURCE_DIR}/kstyle/breezestyleconfigdata.kcfgc")
#kconfig_add_kcfg_files(vinyl_appstyle_SRCS "../decoration/vinylsettings.kcfgc")
#kconfig_add_kcfg_files(vinyl_appstyle_SRCS "vinylstyleconfigdata.kcfgc")

# Compatibility Aliases (QTBUG-114706)
add_library(Qt::Core ALIAS Qt${QT_MAJOR_VERSION}::Core)
add_library(Qt::Gui ALIAS Qt${QT_MAJOR_VERSION}::Gui)

add_library(vinylnxappstyle${QT_MAJOR_VERSION} MODULE "${vinyl_appstyle_SRCS}")

set_target_properties(vinylnxappstyle${QT_MAJOR_VERSION} PROPERTIES
    OUTPUT_NAME vinylnx
)

ecm_qt_declare_logging_category(vinyl_appstyle_SRCS
    HEADER
        "breeze_logging.h"
    IDENTIFIER
        VINYLNX
    CATEGORY_NAME
        vinylnx${QT_MAJOR_VERSION}
    DEFAULT_SEVERITY
        Warning
)

target_compile_definitions(vinylnxappstyle${QT_MAJOR_VERSION} PRIVATE
    "BREEZE=VINYLNX"
    #"BREEZE_VERSION=\"6.0.0\""
)

target_include_directories(vinylnxappstyle${QT_MAJOR_VERSION} PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
    ${BREEZE_SOURCE_DIR}/kstyle
    ${BREEZE_SOURCE_DIR}/libbreezecommon
    ${CMAKE_CURRENT_BINARY_DIR}
)

target_link_libraries(vinylnxappstyle${QT_MAJOR_VERSION}
    PUBLIC
        KF${QT_MAJOR_VERSION}::ConfigCore
        KF${QT_MAJOR_VERSION}::ConfigWidgets
        KF${QT_MAJOR_VERSION}::GuiAddons
        KF${QT_MAJOR_VERSION}::I18n
        KF${QT_MAJOR_VERSION}::IconThemes
        KF${QT_MAJOR_VERSION}::WindowSystem
        Qt${QT_MAJOR_VERSION}::DBus
        Qt${QT_MAJOR_VERSION}::Widgets
        vinylnx::common
)

install(TARGETS vinylnxappstyle${QT_MAJOR_VERSION} DESTINATION "${KDE_INSTALL_PLUGINDIR}/styles")
install(FILES vinylnx.themerc  DESTINATION "${KDE_INSTALL_DATADIR}/kstyle/themes")

#if (QT_MAJOR_VERSION EQUAL "6" AND TARGET "KF6::KCMUtils")
#    add_subdirectory(config)
#endif()

find_package(Doxygen)
set(DOXYFILE_IN Doxyfile.in)
set(DOXYFILE_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
configure_file(${DOXYFILE_IN} ${DOXYFILE_OUT} @ONLY)

if (DOXYGEN_FOUND)
    add_custom_target(doc
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM)
endif()
