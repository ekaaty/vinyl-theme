### configuration plugin
add_definitions(-DTRANSLATION_DOMAIN=\"vinyl_style_config\")

set(kstyle_vinyl_config_PART_SRCS vinylstyleconfig.cpp)
set(kstyle_vinyl_config_PART_SRCS ${kstyle_vinyl_config_PART_SRCS} vinylstyleconfigmodule.cpp)
set(kstyle_vinyl_config_PART_FORMS ui/vinylstyleconfig.ui)

kconfig_add_kcfg_files(kstyle_vinyl_config_PART_SRCS ../vinylstyleconfigdata.kcfgc)
ki18n_wrap_ui(kstyle_vinyl_config_PART_FORMS_HEADERS ${kstyle_vinyl_config_PART_FORMS})

kcoreaddons_add_plugin(vinylstyleconfig
    SOURCES
        ${kstyle_vinyl_config_PART_SRCS}
        ${kstyle_vinyl_config_PART_FORMS_HEADERS}
    INSTALL_NAMESPACE "kstyle_config"
)

target_link_libraries(vinylstyleconfig
    PUBLIC
        Qt${QT_MAJOR_VERSION}::Core
        Qt${QT_MAJOR_VERSION}::Gui
        Qt${QT_MAJOR_VERSION}::Widgets
)

if(HAVE_QTDBUS)
    target_link_libraries(vinylstyleconfig
        PUBLIC
            Qt${QT_MAJOR_VERSION}::DBus
    )
endif()

target_link_libraries(vinylstyleconfig 
    PUBLIC 
        KF${QT_MAJOR_VERSION}::CoreAddons
        KF${QT_MAJOR_VERSION}::ConfigCore
        KF${QT_MAJOR_VERSION}::ConfigWidgets
        KF${QT_MAJOR_VERSION}::I18n
)

if(QT_MAJOR_VERSION STREQUAL "6")
    target_link_libraries(vinylstyleconfig
        PUBLIC
            KF${QT_MAJOR_VERSION}::KCMUtils
    )
endif()
#kcmutils_generate_desktop_file(vinylstyleconfig)

set(vinyl_settings_SOURCES main.cpp)
add_executable(vinyl-settings ${vinyl_settings_SOURCES})
target_link_libraries(vinyl-settings
    PUBLIC
        Qt6::Core
        Qt6::Gui
        Qt6::Widgets
    )

target_link_libraries(vinyl-settings
    PUBLIC
        KF6::CoreAddons
        KF6::KCMUtils
        KF6::I18n
)

set_target_properties(vinyl-settings
    PROPERTIES OUTPUT_NAME vinyl-settings${QT_MAJOR_VERSION}
)

install(
    TARGETS vinyl-settings ${KDE_INSTALL_TARGETS_DEFAULT_ARGS}
)

# icon
#ecm_install_icons(ICONS sc-apps-vinyl-settings.svgz
#    DESTINATION ${KDE_INSTALL_ICONDIR}
#    THEME hicolor
#)
