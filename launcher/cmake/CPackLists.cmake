cmake_minimum_required(VERSION 3.16)

set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_OUTPUT_FILE_PREFIX "${PROJECT_SOURCE_DIR}/dist")
set(CPACK_VERBATIM_VARIABLES YES)

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

set(CPACK_GENERATOR "TGZ")
set(CPACK_TOPLEVEL_TAG "plasma")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
set(CPACK_IGNORE_FILES "${SourceIgnoreFiles}")
set(CPACK_OUTPUT_CONFIG_FILE "${PROJECT_BINARY_DIR}/CPackConfig.cmake")
configure_file(
  "${PROJECT_SOURCE_DIR}/cmake/CPackConfig.cmake.in"
  "${PROJECT_BINARY_DIR}/CPackConfig.cmake"
  @ONLY
)

set(CPACK_SOURCE_GENERATOR "TXZ")
set(CPACK_SOURCE_TOPLEVEL_TAG "plasma-source")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}.${CPACK_SOURCE_TOPLEVEL_TAG}")
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

add_custom_target(bdist
  COMMAND "${CMAKE_COMMAND}"
    --build "${CMAKE_BINARY_DIR}"
    --target package
  VERBATIM
  USES_TERMINAL
)

# vim: ts=2:sw=2:sts=2:et:syntax=cmake
