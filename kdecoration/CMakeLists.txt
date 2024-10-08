add_definitions(-DTRANSLATION_DOMAIN="vinyl_kwin_deco")

################# configuration #################
configure_file(config-vinyl.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-vinyl.h )

################# includes #################
include_directories(${CMAKE_SOURCE_DIR}/libvinylcommon)
include_directories(${CMAKE_BINARY_DIR}/libvinylcommon)

################# newt target #################
### plugin classes
set(vinyldecoration_SRCS
    vinylbutton.cpp
    vinyldecoration.cpp
    vinylexceptionlist.cpp
    vinylsettingsprovider.cpp
    vinylsizegrip.cpp
)
### build library
kconfig_add_kcfg_files(vinyldecoration_SRCS vinylsettings.kcfgc)
add_library(vinyldecoration MODULE
    ${vinyldecoration_SRCS}
    ${vinyldecoration_config_SRCS}
    ${vinyldecoration_config_PART_FORMS_HEADERS})

set_target_properties(vinyldecoration PROPERTIES
    OUTPUT_NAME org.kde.vinyl
)

target_link_libraries(vinyldecoration
     PUBLIC
        Qt6::Core
        Qt6::Gui
        Qt6::DBus
        KDecoration2::KDecoration
     PRIVATE
        vinylcommon6
        KF6::CoreAddons
        KF6::ConfigWidgets
        KF6::GuiAddons
        KF6::I18n
        KF6::IconThemes
        KF6::WindowSystem
        KF6::KCMUtils
)

install(TARGETS vinyldecoration DESTINATION ${KDE_INSTALL_PLUGINDIR}/${KDECORATION_PLUGIN_DIR})
install(FILES config/vinyldecorationconfig.desktop DESTINATION  ${KDE_INSTALL_DATADIR}/kservices6)

add_subdirectory(config)
