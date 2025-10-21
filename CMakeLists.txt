cmake_minimum_required(VERSION 3.16)

# Get version
file(READ "${CMAKE_SOURCE_DIR}/VERSION" VER_RAW)
string(STRIP ${VER_RAW} VER)

project(
    vinyl
    DESCRIPTION "A theme for KDE Plasma"
    VERSION ${VER}
)

set(KF6_MIN_VERSION "6.13.0")
set(KDE_COMPILERSETTINGS_LEVEL "5.82")
set(QT_MIN_VERSION "6.8.0")
set(PLASMA_MIN_VERSION "6.3.0")

include(cmake/CMakeUpdateEnvFile.cmake)
include(GenerateExportHeader)
include(WriteBasicConfigVersionFile)
include(FeatureSummary)

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH}  ${CMAKE_SOURCE_DIR}/cmake)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(cmake/CPackLists.cmake)

# We need this because we can't include KDECMakeSettings here, because that
# would need KDEInstallDirs, which we can only include in the qt{5,6} builds
# to get the correct installation dirs for each Qt version.
option(BUILD_TESTING "Build the testing tree." ON)
if(BUILD_TESTING)
    enable_testing()
endif()

include(CMakePackageConfigHelpers)
include(ECMInstallIcons)
include(ECMQtDeclareLoggingCategory)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(KDEGitCommitHooks)

include(GtkUpdateIconCache)

option(BUILD_QT6 "Build with Qt6" ON)

set(QT_NO_CREATE_VERSIONLESS_TARGETS ON)
set(QT_NO_CREATE_VERSIONLESS_FUNCTIONS ON)

function(build_Qt6)
    set(QT_MAJOR_VERSION 6)
    include(KDEInstallDirs6)
    include(KDECMakeSettings)

    if(UNIX AND NOT APPLE AND NOT ANDROID)
        find_package(Qt6 ${REQUIRED_QT_VERSION} CONFIG REQUIRED DBus)
        set(HAVE_QTDBUS ${Qt6DBus_FOUND})

        option(WITH_APPSTYLE_ONLY "Build application style only" OFF)
        option(WITH_DECORATIONS "Build Vinyl window decorations for KWin" ON)
        option(WITH_MOZILLA "Build Vinyl Mozilla Firefox themes" OFF)

        if(NOT ${WITH_APPSTYLE_ONLY})
            option(WITH_DESKTOPTHEME "Build Vinyl plasma desktop theme" ON)
            option(WITH_GLOBALTHEMES "Build Vinyl global themes" ON)
            option(WITH_ICONS "Build Vinyl icon themes" ON)
            option(WITH_KONSOLE "Build Vinyl Konsole themes" ON)
            option(WITH_LAYOUT_TEMPLATES "Build Vinyl layout templates" ON)
            option(WITH_MENULAUNCHER "Build Vinyl menu launcher applet" ON)
            option(WITH_SDDM "Build Vinyl SDDM theme" ON)
            option(WITH_SPLASHSCREEN "Build Vinyl splash screen" ON)
            option(WITH_WALLPAPERS "Install Vinyl default wallpapers" ON)
        endif()

        find_package(KF6FrameworkIntegration ${KF6_MIN_VERSION} CONFIG )
        set_package_properties(KF${QT_MAJOR_VERSION}FrameworkIntegration PROPERTIES
            DESCRIPTION "KF6 Framework Integration"
            URL "https://projects.kde.org/projects/frameworks/frameworkintegration"
            TYPE OPTIONAL
            PURPOSE "Required to use KStyle convenience functionalities in style")

        find_package(KF6KCMUtils ${KF6_MIN_VERSION})
        set_package_properties(KF6KCMUtils PROPERTIES
            TYPE REQUIRED
            DESCRIPTION "Helps create configuration modules"
            PURPOSE "KCMUtils used for the configuration modules or the decoration and Qt Style"
        )
    else()
        set(WITH_DECORATIONS OFF)
        set(WITH_DESKTOPTHEME OFF)
        set(WITH_GLOBALTHEMES OFF)
        set(WITH_ICONS OFF)
        set(WITH_KONSOLE OFF)
        set(WITH_LAYOUT_TEMPLATES OFF)
        set(WITH_MENULAUNCHER OFF)
        set(WITH_MOZILLA OFF)
        set(WITH_SDDM OFF)
        set(WITH_SPLASHSCREEN OFF)
        set(WITH_WALLPAPERS OFF)
    endif()

    find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Widgets Core)

    find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
        CoreAddons
        ColorScheme
        Config
        GuiAddons
        I18n
        IconThemes
        WindowSystem)

    find_package(Qt6 ${QT_MIN_VERSION} OPTIONAL_COMPONENTS Quick)
    if(${Qt6Quick_FOUND})
        find_package(KF6KirigamiPlatform ${KF6_MIN_VERSION} REQUIRED)
    endif()

    set(VINYL_HAVE_KSTYLE ${KF6FrameworkIntegration_FOUND})
    set(VINYL_HAVE_QTQUICK ${Qt6Quick_FOUND})

    # https://bugreports.qt.io/browse/QTBUG-114706
    add_library(Qt::Core ALIAS Qt6::Core)
    add_library(Qt::Gui ALIAS Qt6::Gui)
    add_library(Qt::OpenGL ALIAS Qt6::OpenGL)
    add_library(Qt::Network ALIAS Qt6::Network)
    if(Qt6_VERSION_MINOR GREATER 6)
        add_library(Qt::PlatformModuleInternal ALIAS Qt6::PlatformModuleInternal)
    endif()

    add_subdirectory(kstyle kstyle6)
    add_subdirectory(libvinylcommon libvinylcommon6)
    #add_subdirectory(misc)

    if(WITH_DECORATIONS)
        find_package(KDecoration3 REQUIRED)
        add_subdirectory(kdecoration)
    endif()
    if(WITH_DESKTOPTHEME)
        add_subdirectory(desktoptheme)
    endif()
    if(WITH_GLOBALTHEMES)
        add_subdirectory(plasma/look-and-feel)
    endif()
    if (WITH_ICONS)
        add_subdirectory(icons)
    endif()
    if (WITH_KONSOLE)
        add_subdirectory(konsole)
    endif()
    if(WITH_LAYOUT_TEMPLATES)
        add_subdirectory(plasma/layout-templates)
    endif()
    if(WITH_MENULAUNCHER)
        add_subdirectory(launcher)
    endif()
    if (WITH_MOZILLA)
        add_subdirectory(mozilla)
    endif()
    if (WITH_SDDM)
        add_subdirectory(sddm)
    endif()
    if(WITH_SPLASHSCREEN)
        add_subdirectory(splash)
    endif()
    if (WITH_WALLPAPERS)
        add_subdirectory(wallpapers)
    endif()

    ki18n_install(po)

    # create a Config.cmake and a ConfigVersion.cmake file and install them
    include(ECMSetupVersion)
    ecm_setup_version(${PROJECT_VERSION} VARIABLE_PREFIX VINYL
        PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/VinylConfigVersion.cmake"
        VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kstyle6/config/vinylstyleversion.h"
    )
    set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/Vinyl")

    configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/VinylConfig.cmake.in"
                                  "${CMAKE_CURRENT_BINARY_DIR}/VinylConfig.cmake"
                                  PATH_VARS KDE_INSTALL_FULL_DATADIR
                                  INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
    )
    install(FILES  "${CMAKE_CURRENT_BINARY_DIR}/VinylConfig.cmake"
                   "${CMAKE_CURRENT_BINARY_DIR}/VinylConfigVersion.cmake"
            DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
            COMPONENT Devel
    )

    unset(QUERY_EXECUTABLE CACHE)
endfunction()
if(BUILD_QT6)
    build_Qt6()
endif()

function(build_colors_and_cursors)
    # While it is technically not 100% correct to use versionless
    # KDEInstallDirs while (maybe) building for both Qt versions,
    # it doesn't really matter at the end, because colors and cursors
    # only use ICONDIR and DATADIR which both do not depend on the version
    include(KDEInstallDirs)
    add_subdirectory(colors)
    add_subdirectory(cursors)
endfunction()

if(NOT ${WITH_APPSTYLE_ONLY})
    build_colors_and_cursors()
endif()

# add clang-format target for all our real source files
find_program(KDE_CLANG_FORMAT_EXECUTABLE clang-format OPTIONAL)
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
if(${KDE_CLANG_FORMAT_EXECUTABLE})
    kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
endif()
kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)

#add_custom_target(clean-all
#    COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR} && grep -vE '^build/' .gitignore | xargs -n1 rm -rf && cd - >/dev/null 2>&1
#)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
