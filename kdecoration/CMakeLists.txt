add_definitions(-DTRANSLATION_DOMAIN="vinyl_kwin_deco")

################# includes #################
include_directories(${CMAKE_SOURCE_DIR}/libvinylcommon)
include_directories(${CMAKE_BINARY_DIR}/libvinylcommon)

################# newt target #################
### plugin classes
set(vinyldecoration_SRCS
    vinylbutton.cpp
    vinyldecoration.cpp
    vinylsettingsprovider.cpp
    vinylexceptionlist.cpp
)

### build library
kconfig_add_kcfg_files(vinyldecoration_SRCS vinylsettings.kcfgc)
add_library(vinyldecoration MODULE
    ${vinyldecoration_SRCS}
    ${vinyldecoration_config_PART_FORMS_HEADERS})

set_target_properties(vinyldecoration PROPERTIES
    OUTPUT_NAME org.kde.vinyl
)

target_link_libraries(vinyldecoration
    PRIVATE
        vinylcommon6
        Qt6::DBus
        KF6::CoreAddons
        KF6::ConfigGui
        KF6::GuiAddons
        KF6::I18n
        KF6::IconThemes
        KDecoration3::KDecoration
)

install(TARGETS vinyldecoration DESTINATION ${KDE_INSTALL_PLUGINDIR}/${KDECORATION_PLUGIN_DIR})

add_subdirectory(config)

