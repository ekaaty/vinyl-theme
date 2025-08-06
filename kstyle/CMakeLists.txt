################# includes #################
include_directories(
  animations
  debug
)

include_directories(${CMAKE_SOURCE_DIR}/libvinylcommon)
include_directories(${CMAKE_BINARY_DIR}/libvinylcommon)

################# configuration #################
configure_file(config-vinyl.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-vinyl.h)

########### next target ###############
set(vinyl_PART_SRCS
    animations/vinylanimation.cpp
    animations/vinylanimations.cpp
    animations/vinylanimationdata.cpp
    animations/vinylbaseengine.cpp
    animations/vinylbusyindicatordata.cpp
    animations/vinylbusyindicatorengine.cpp
    animations/vinyldialdata.cpp
    animations/vinyldialengine.cpp
    animations/vinylenabledata.cpp
    animations/vinylgenericdata.cpp
    animations/vinylheaderviewdata.cpp
    animations/vinylheaderviewengine.cpp
    animations/vinylscrollbardata.cpp
    animations/vinylscrollbarengine.cpp
    animations/vinylspinboxengine.cpp
    animations/vinylspinboxdata.cpp
    animations/vinylstackedwidgetdata.cpp
    animations/vinylstackedwidgetengine.cpp
    animations/vinyltabbarengine.cpp
    animations/vinyltabbardata.cpp
    animations/vinyltoolboxengine.cpp
    animations/vinyltransitiondata.cpp
    animations/vinyltransitionwidget.cpp
    animations/vinylwidgetstateengine.cpp
    animations/vinylwidgetstatedata.cpp
    debug/vinylwidgetexplorer.cpp
    vinyladdeventfilter.cpp
    vinylblurhelper.cpp
    vinylframeshadow.cpp
    vinylhelper.cpp
    vinylmdiwindowshadow.cpp
    vinylmnemonics.cpp
    vinylpropertynames.cpp
    vinylshadowhelper.cpp
    vinylsplitterproxy.cpp
    vinylstyle.cpp
    vinylstyleplugin.cpp
    vinyltileset.cpp
    vinylwindowmanager.cpp
)

kconfig_add_kcfg_files(vinyl_PART_SRCS ../kdecoration/vinylsettings.kcfgc)
kconfig_add_kcfg_files(vinyl_PART_SRCS vinylstyleconfigdata.kcfgc)

add_library(vinyl${QT_MAJOR_VERSION} MODULE ${vinyl_PART_SRCS})

target_link_libraries(vinyl${QT_MAJOR_VERSION}
    Qt${QT_MAJOR_VERSION}::Core
    Qt${QT_MAJOR_VERSION}::Gui
    Qt${QT_MAJOR_VERSION}::Widgets
    Qt${QT_MAJOR_VERSION}::DBus
)

if( VINYL_HAVE_QTQUICK )
    target_link_libraries(vinyl${QT_MAJOR_VERSION}
        Qt${QT_MAJOR_VERSION}::Quick
        KF${QT_MAJOR_VERSION}::CoreAddons
    )
endif()

target_link_libraries(vinyl${QT_MAJOR_VERSION}
    KF${QT_MAJOR_VERSION}::CoreAddons
    KF${QT_MAJOR_VERSION}::ConfigCore
    KF${QT_MAJOR_VERSION}::ConfigGui
    KF${QT_MAJOR_VERSION}::GuiAddons
    KF${QT_MAJOR_VERSION}::IconThemes
    KF${QT_MAJOR_VERSION}::WindowSystem
)

if(QT_MAJOR_VERSION STREQUAL "6")
    target_link_libraries(vinyl6 KF6::ColorScheme)
    if (VINYL_HAVE_QTQUICK)
        target_link_libraries(vinyl6 KF6::KirigamiPlatform)
    endif()
endif()


target_link_libraries(vinyl${QT_MAJOR_VERSION} vinylcommon${QT_MAJOR_VERSION})

if(KF${QT_MAJOR_VERSION}FrameworkIntegration_FOUND)
    target_link_libraries(vinyl${QT_MAJOR_VERSION}  KF${QT_MAJOR_VERSION}::Style)
endif()


if (WIN32)
    # As stated in https://docs.microsoft.com/en-us/cpp/c-runtime-library/math-constants M_PI only gets defined
    # when if _USE_MATH_DEFINES is defined
    target_compile_definitions(vinyl PRIVATE _USE_MATH_DEFINES _BSD_SOURCE)
endif()


########### install files ###############
install(TARGETS vinyl${QT_MAJOR_VERSION} DESTINATION ${KDE_INSTALL_QTPLUGINDIR}/styles/)
install(FILES vinyl.themerc  DESTINATION  ${KDE_INSTALL_DATADIR}/kstyle/themes)

########### subdirectories ###############

if (QT_MAJOR_VERSION EQUAL "6" AND TARGET "KF6::KCMUtils")
    add_subdirectory(config)
endif()
