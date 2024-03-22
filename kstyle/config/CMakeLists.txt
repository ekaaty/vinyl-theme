### configuration plugin
add_definitions(-DTRANSLATION_DOMAIN=\"vinyl_style_config\")
set(kstyle_vinyl_config_PART_SRCS vinylstyleconfig.cpp)

set(kstyle_vinyl_config_PART_SRCS ${kstyle_vinyl_config_PART_SRCS} vinylstyleconfigmodule.cpp)

kconfig_add_kcfg_files(kstyle_vinyl_config_PART_SRCS ../vinylstyleconfigdata.kcfgc)
set(kstyle_vinyl_config_PART_FORMS ui/vinylstyleconfig.ui)
ki18n_wrap_ui(kstyle_vinyl_config_PART_FORMS_HEADERS ${kstyle_vinyl_config_PART_FORMS})

kcoreaddons_add_plugin(vinylstyleconfig SOURCES
    ${kstyle_vinyl_config_PART_SRCS}
    ${kstyle_vinyl_config_PART_FORMS_HEADERS}
    INSTALL_NAMESPACE "kstyle_config"
)

target_link_libraries(vinylstyleconfig Qt6::Core Qt6::Gui Qt6::Widgets Qt6::DBus)
target_link_libraries(vinylstyleconfig KF6::CoreAddons KF6::ConfigCore KF6::ConfigWidgets KF6::I18n)
if(QT_MAJOR_VERSION STREQUAL "6")
    target_link_libraries(vinylstyleconfig KF6::KCMUtils)
endif()
kcmutils_generate_desktop_file(vinylstyleconfig)

set(vinyl_settings_SOURCES main.cpp)
add_executable(vinyl-settings ${vinyl_settings_SOURCES} )
target_link_libraries(vinyl-settings Qt6::Core Qt6::Gui Qt6::Widgets )
target_link_libraries(vinyl-settings KF6::I18n KF6::KCMUtils KF6::CoreAddons)

set_target_properties(vinyl-settings PROPERTIES OUTPUT_NAME vinyl-settings${QT_MAJOR_VERSION})

install(TARGETS vinyl-settings ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

# icon
ecm_install_icons(ICONS sc-apps-vinyl-settings.svgz
    DESTINATION ${KDE_INSTALL_ICONDIR}
    THEME hicolor )


