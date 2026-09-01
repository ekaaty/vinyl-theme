# @file CMakeLists.txt
# @brief The main CMakeLists.txt for Vinyl Theme.
#
# SPDX-FileCopyrightText: 2025 Christian Tosta
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.21)

# Force Ninja as build generator
if(NOT CMAKE_GENERATOR)
    set(CMAKE_GENERATOR "Ninja" CACHE STRING "Set build generator" FORCE)
endif()

if(NOT CMAKE_GENERATOR MATCHES "Ninja")
    message(
        WARNING "This project requires Ninja. Configure it with:
        cmake --preset default"
    )
endif()

# Populates all PACKAGE_* variables based on metadata.json
include(cmake/ParseMetadata.cmake)

set(VERSION_REGEX "^(\\d+)\\.(\\d+)\\.(\\d+)")
string(REGEX REPLACE ${VERSION_REGEX} "\\1" VINYL_VERSION_MAJOR "${PACKAGE_VERSION}")
string(REGEX REPLACE ${VERSION_REGEX} "\\2" VINYL_VERSION_MINOR "${PACKAGE_VERSION}")
string(REGEX REPLACE ${VERSION_REGEX} "\\3" VINYL_VERSION_PATCH "${PACKAGE_VERSION}")

# Initialize the project
project(
    ${PACKAGE_NAME}
    VERSION ${PACKAGE_VERSION}
    DESCRIPTION "${PACKAGE_SUMMARY}"
)

set(APPLICATION_ID "com.ekaaty.vinylnx")
set(ORGANIZATION_NAME "Ekaaty")
set(ORGANIZATION_DOMAIN "ekaaty.com")

# Properly set the install prefix via environment variable PREFIX
if(DEFINED ENV{PREFIX} AND NOT "$ENV{PREFIX}" STREQUAL "")
    set(CMAKE_INSTALL_PREFIX "$ENV{PREFIX}" CACHE PATH "Install prefix" FORCE)
endif()

# Look for required Breeze source (TODO [?]: Migrate this to metadata.json)
set(BREEZE_COMMIT_HASH "8f5f92db32cf485f2fbe19b59ccb2f4f46e69096") # 6.7.4
include(cmake/BreezeCheckOut.cmake)

include(GenerateExportHeader)
include(WriteBasicConfigVersionFile)
include(FeatureSummary)

find_package(ECM ${KF5_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# We need this because we can't include KDECMakeSettings here, because that
# would need KDEInstallDirs, which we can only include in the qt{5,6} builds
# to get the correct installation dirs for each Qt version.
option(BUILD_TESTING "Build the testing tree." ON)
if(BUILD_TESTING)
    enable_testing()
endif()

include(cmake/CPackLists.cmake)
include(CMakePackageConfigHelpers)
include(ECMInstallIcons)
include(ECMQtDeclareLoggingCategory)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(KDEGitCommitHooks)

include(GtkUpdateIconCache)

option(BUILD_QT5 "Build Qt5 style" OFF)
option(BUILD_QT6 "Build with Qt6" ON)
option(BUILD_WITH_QTQUICK "Build with Qt Quick and Kirigami features enabled" ON)

set(QT_NO_CREATE_VERSIONLESS_TARGETS ON)
set(QT_NO_CREATE_VERSIONLESS_FUNCTIONS ON)

#include(cmake/BuildQt5.cmake)
include(cmake/BuildQt6.cmake)

function(build_colors_and_cursors)
    # While it is technically not 100% correct to use versionless
    # KDEInstallDirs while (maybe) building for both Qt versions,
    # it doesn't really matter at the end, because colors and cursors
    # only use ICONDIR and DATADIR which both do not depend on the version
    include(KDEInstallDirs)
    add_subdirectory(colors)
    add_subdirectory(cursors)
endfunction()

# NOTE: For now we build only the KStyle
option(WITH_APPSTYLE_ONLY "Build application style only" ON)
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

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
