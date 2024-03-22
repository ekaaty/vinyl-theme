#####  config classes ææææææ

set(vinyldecoration_config_SRCS
  ../vinylexceptionlist.cpp
    vinylconfigwidget.cpp
    vinyldetectwidget.cpp
    vinylexceptiondialog.cpp
    vinylexceptionlistwidget.cpp
    vinylexceptionmodel.cpp
    vinylitemmodel.cpp
)
ki18n_wrap_ui(vinyldecoration_config_SRCS
    ui/vinylconfigurationui.ui
    ui/vinyldetectwidget.ui
    ui/vinylexceptiondialog.ui
    ui/vinylexceptionlistwidget.ui
)

kcoreaddons_add_plugin(kcm_vinyldecoration SOURCES kcm_vinyldecoration.cpp ${vinyldecoration_config_SRCS} INSTALL_NAMESPACE "${KDECORATION_KCM_PLUGIN_DIR}")
kconfig_add_kcfg_files(kcm_vinyldecoration ../vinylsettings.kcfgc)
target_include_directories(kcm_vinyldecoration PRIVATE ${CMAKE_SOURCE_DIR}/kdecoration ${CMAKE_BINARY_DIR}/kdecoration/)
target_link_libraries(kcm_vinyldecoration
     PUBLIC
        Qt6::Core
        Qt6::Gui
        Qt6::DBus
        KDecoration2::KDecoration
     PRIVATE
        KF6::CoreAddons
        KF6::ConfigWidgets
        KF6::GuiAddons
        KF6::I18n
        KF6::IconThemes
        KF6::WindowSystem
        KF6::KCMUtils
)
kcmutils_generate_desktop_file(kcm_vinyldecoration)
