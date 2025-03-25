cmake_minimum_required(VERSION 3.16)

if( CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR )
project(vinyl-mozilla)
string(TIMESTAMP PROJECT_VERSION "%Y%m%d")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
SET(CPACK_OUTPUT_FILE_PREFIX "${PROJECT_SOURCE_DIR}/dist")
set(CPACK_GENERATOR "TGZ")
set(CPACK_TOPLEVEL_TAG "")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
set(CPACK_IGNORE_FILES  "\\.git/;.gitignore;build/;_CPack_Packages/;dist/;tmp/;[^-]+\\.tar\\.[abx2]*")
set(CPACK_OUTPUT_CONFIG_FILE "${PROJECT_BINARY_DIR}/CPackConfig.cmake")
set(CPACK_SOURCE_GENERATOR "TGZ")
set(CPACK_SOURCE_TOPLEVEL_TAG "source")
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

add_custom_target(vinyl-blue-dark
	COMMAND cp -a ${CMAKE_CURRENT_SOURCE_DIR}/src/vinyl-blue-dark/ .
)
add_custom_target(vinyl-blue-light
	COMMAND cp -a ${CMAKE_CURRENT_SOURCE_DIR}/src/vinyl-blue-light/ .
)

add_custom_target(vinyl-blue-dark.xpi
	COMMAND cd vinyl-blue-dark && zip -r -FS ../vinyl-blue-dark.xpi * --exclude '*.git*'
	DEPENDS vinyl-blue-dark
)
add_custom_target(vinyl-blue-light.xpi
	COMMAND cd vinyl-blue-light && zip -r -FS ../vinyl-blue-light.xpi * --exclude '*.git*'
	DEPENDS vinyl-blue-light
)
add_custom_target(extensions ALL
	DEPENDS vinyl-blue-dark.xpi vinyl-blue-light.xpi
)

install(FILES
	    build/vinyl-blue-dark.xpi
	    build/vinyl-blue-light.xpi
        DESTINATION .
)
