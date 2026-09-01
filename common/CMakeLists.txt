# @file CMakeLists.txt
# @brief CMake Lists for Vinyl Rust library.
#
# SPDX-FileCopyrightText: 2026 Christian Tosta
# SPDX-License-Identifier: BSD-3-Clause

# Add ExternalProject support to manage Cargo
include(ExternalProject)

# Optical motor in Rust
set(RUST_LIB_NAME vinylnx_core)
set(RUST_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/rust")
set(RUST_TARGET_DIR "${CMAKE_CURRENT_BINARY_DIR}/rust/target")
set(RUST_STATIC_LIB "${RUST_SOURCE_DIR}/target/release/lib${RUST_LIB_NAME}.a")

ExternalProject_Add(rust_target
    SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/rust"
    BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/rust"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND cargo build --release --manifest-path "${RUST_SOURCE_DIR}/Cargo.toml"
    INSTALL_COMMAND ""
    BUILD_BYPRODUCTS "${RUST_STATIC_LIB}"
)


find_package(Qt${QT_MAJOR_VERSION} ${QT${QT_MAJOR_VERSION}_MIN_VERSION} REQUIRED COMPONENTS
    Core
    Gui
)

find_package(KF${QT_MAJOR_VERSION} ${KF${QT_MAJOR_VERSION}_MIN_VERSION} REQUIRED COMPONENTS
    GuiAddons
)

set(breezecommon_SRCS
    "${BREEZE_SOURCE_DIR}/libbreezecommon/breezeboxshadowrenderer.cpp"
)

set(vinylcommon_SRCS
    "${breezecommon_SRCS}"
    "vinylopticalhelper.cpp"
)

add_library(rust_lib_static STATIC IMPORTED GLOBAL)
add_dependencies(rust_lib_static rust_target)
set_target_properties(rust_lib_static PROPERTIES
    IMPORTED_LOCATION "${RUST_STATIC_LIB}"
)

add_library(vinylnxcommon${QT_MAJOR_VERSION} STATIC "${vinylcommon_SRCS}")
add_dependencies(vinylnxcommon${QT_MAJOR_VERSION} rust_target)
set_target_properties(vinylnxcommon${QT_MAJOR_VERSION} PROPERTIES POSITION_INDEPENDENT_CODE TRUE)
target_link_libraries(vinylnxcommon${QT_MAJOR_VERSION}
    PUBLIC
        Qt${QT_MAJOR_VERSION}::Gui
        KF${QT_MAJOR_VERSION}::GuiAddons
    PRIVATE
        rust_lib_static
        dl
        pthread
)

add_library(vinylnx::common ALIAS vinylnxcommon${QT_MAJOR_VERSION})
