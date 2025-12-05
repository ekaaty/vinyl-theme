cmake_minimum_required(VERSION 3.16)

set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_OUTPUT_FILE_PREFIX "${PROJECT_SOURCE_DIR}/dist")
set(CPACK_VERBATIM_VARIABLES YES)

if(WITH_APPSTYLE_ONLY)
    set(SourceIgnoreDirs
        "colors/"
        "cursors/"
        "desktoptheme/"
        "icons/"
        "konsole/"
        "launcher/"
        "mozilla/"
        "plasma/"
        "sddm/"
        "splash/"
        "wallpapers/"
    )
else()
    set(SourceIgnoreDirs "")
endif()

set(SourceIgnoreFiles 
    ".cache"
    ".copr"
    ".clang-format"
    ".clangd"
    ".git/"
    ".gitea/"
    ".github/"
    ".gitignore"
    ".idea"
    "CMakeCache.txt"
    "CMakeFiles/"
    "CPackConfig.cmake$"
    "CPackSourceConfig.cmake"
    "CTestTestfile.cmake"
    "Makefile"
    "_CPack_Packages/"
    "build/"
    "cmake-build*"
    "cmake_install.cmake"
    "dist/"
    ${SourceIgnoreDirs}
)

# Escape any '.' and '/' characters
string(REPLACE "." "\\\." SourceIgnoreFiles "${SourceIgnoreFiles}")
string(REPLACE "/" "\\\/" SourceIgnoreFiles "${SourceIgnoreFiles}")

# Override install prefix for package target
set(CMAKE_INSTALL_PREFIX ".")
string(REGEX REPLACE "^/(.*)" "\\1" 
    CPACK_PACKAGING_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}"
)
set(CPACK_SET_DESTDIR ON)

set(CPACK_SOURCE_GENERATOR "TXZ")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
set(CPACK_SOURCE_IGNORE_FILES "${SourceIgnoreFiles}")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "${PROJECT_BINARY_DIR}/CPackSourceConfig.cmake")
configure_file(
    "${PROJECT_SOURCE_DIR}/cmake/CPackConfig.cmake.in"
    "${PROJECT_BINARY_DIR}/CPackSourceConfig.cmake"
    @ONLY
)

include(CPack)

add_custom_target(sdist
    COMMAND "${CMAKE_COMMAND}"
        --build "${CMAKE_BINARY_DIR}"
        --target package_source
    VERBATIM
    USES_TERMINAL
)

# vim: ts=4:sw=4:sts=4:et:syntax=cmake
