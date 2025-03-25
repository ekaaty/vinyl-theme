cmake_minimum_required(VERSION 3.16)

if( CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR )
project(vinyl-konsole)
string(TIMESTAMP PROJECT_VERSION "%Y%m%d")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
SET(CPACK_OUTPUT_FILE_PREFIX "${PROJECT_SOURCE_DIR}/dist")
set(CPACK_GENERATOR "TGZ")
set(CPACK_TOPLEVEL_TAG "plasma")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
set(CPACK_IGNORE_FILES  "\\.git/;.gitignore;build/;_CPack_Packages/;dist/;tmp/;[^-]+\\.tar\\.[abx2]*")
set(CPACK_OUTPUT_CONFIG_FILE "${PROJECT_BINARY_DIR}/CPackConfig.cmake")
set(CPACK_SOURCE_GENERATOR "TXZ")
set(CPACK_SOURCE_TOPLEVEL_TAG "plasma-source")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}.${CPACK_SOURCE_TOPLEVEL_TAG}")
set(CPACK_SOURCE_IGNORE_FILES  "\\.git/;.gitignore;build/;_CPack_Packages/;dist/;tmp/;[^-]+\\.tar\\.[abx2]*")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "${PROJECT_BINARY_DIR}/CPackSourceConfig.cmake")
set(CPACK_VERBATIM_VARIABLES YES)
configure_file("${PROJECT_SOURCE_DIR}/../cmake/CPackConfig.cmake.in"
               "${PROJECT_BINARY_DIR}/CPackConfig.cmake"
               @ONLY)
configure_file("${PROJECT_SOURCE_DIR}/../cmake/CPackConfig.cmake.in"
               "${PROJECT_BINARY_DIR}/CPackSourceConfig.cmake"
               @ONLY)
include(CPack)
else()
# We are building as part of Main project
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH}  ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)
include(KDEInstallDirs6)

install(FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/Vinyl-Dark.colorscheme
            ${CMAKE_CURRENT_SOURCE_DIR}/src/Vinyl-Light.colorscheme
        DESTINATION  ${KDE_INSTALL_DATADIR}/konsole/
)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/Vinyl.profile
        DESTINATION  ${KDE_INSTALL_DATADIR}/konsole/
)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/profile.d/
        DESTINATION ${KDE_INSTALL_DATADIR}/konsole/profile.d/
)
