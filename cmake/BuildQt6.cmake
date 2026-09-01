# @file BuildQt6.cmake
# @brief This files defines a CMake function used to build Qt6 variant of Vinyl Theme.
#
# SPDX-FileCopyrightText: 2026 Christian Tosta
# SPDX-License-Identifier: BSD-3-Clause

function(build_Qt6)
    set(QT_MAJOR_VERSION 6)
    set(KDECORATION KDecoration3::KDecoration)

    include(KDEInstallDirs${QT_MAJOR_VERSION})
    include(KDECMakeSettings)
    include(KDECompilerSettings NO_POLICY_SCOPE)

    #option(WITH_APPSTYLE_ONLY "Build application style only" OFF)

    set(VINYL_MODULES
        "APPSTYLE:kstyle:Build application style:ON"
        "DECORATIONS:kdecoration:Build Vinyl window decorations for KWin:ON"
        "MOZILLA:mozilla:Build Vinyl Mozilla themes:OFF"
    )

    if(NOT WITH_APPSTYLE_ONLY)
        include(cmake/CMakeUpdateEnvFile.cmake)
        set(VINYL_MODULES
            "APPSTYLE:kstyle:Build application style:ON"
            "DECORATIONS:kdecoration:Build Vinyl window decorations for KWin:ON"
            "DESKTOPTHEME:plasma/desktoptheme:Build Vinyl plasma desktop theme:ON"
            "GLOBALTHEMES:plasma/look-and-feel:Build Vinyl global themes:ON"
            "ICONS:icons:Build Vinyl icon themes:ON"
            "KONSOLE:konsole:Build Vinyl Konsole themes:ON"
            "LAYOUT_TEMPLATES:plasma/layout-templates:Build Vinyl layout templates:ON"
            "MENULAUNCHER:plasma/plasmoids/launcher:Build Vinyl menu launcher applet:ON"
            "MOZILLA:mozilla:Build Vinyl Mozilla themes:ON"
            "SDDM:sddm:Build Vinyl SDDM theme:ON"
            "SPLASHSCREEN:plasma/splash:Build Vinyl splash screen:ON"
            "WALLPAPERS:wallpapers:Install Vinyl default wallpapers:ON"
        )
    endif()

    add_subdirectory(common)

    foreach(_entry IN LISTS VINYL_MODULES)
        string(REPLACE ":" ";" _entry_list "${_entry}")
        list(GET _entry_list 0 _option_var)
        list(GET _entry_list 1 _dir_name)
        list(GET _entry_list 2 _option_desc)
        list(GET _entry_list 3 _option_set)

        message("-- Option: WITH_${_option_var} \"${_option_desc}\" ${_option_set}")
        option(WITH_${_option_var} "${_option_desc}" ${_option_set})

        if(WITH_${_option_var})
            if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${_dir_name}/CMakeLists.txt")
                add_subdirectory(${_dir_name})
            endif()
        endif()
    endforeach()

    if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/po")
        ki18n_install(po)
    endif()

    include(ECMSetupVersion)
    ecm_setup_version(${PROJECT_VERSION} VARIABLE_PREFIX VINYLNX
        PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/VinylConfigVersion.cmake"
        VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kstyle/config/vinylstyleversion.h"
    )
endfunction()

if(BUILD_QT6)
    build_Qt6()
endif()
