cmake_minimum_required(VERSION 3.16)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    project(vinyl-mozilla)
    string(TIMESTAMP PROJECT_VERSION "%Y%m%d")

    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
endif()

add_custom_target(vinyl-blue-dark
    COMMAND cp -a
        ${CMAKE_CURRENT_SOURCE_DIR}/src/vinyl-blue-dark/
        ${CMAKE_BINARY_DIR}
)
add_custom_target(vinyl-blue-light
    COMMAND cp -a
        ${CMAKE_CURRENT_SOURCE_DIR}/src/vinyl-blue-light/
        ${CMAKE_BINARY_DIR}
)

add_custom_target(vinyl-blue-dark.xpi
    COMMAND cd vinyl-blue-dark
        && zip -r -FS ../vinyl-blue-dark.xpi * --exclude '*.git*'
    DEPENDS vinyl-blue-dark
)
add_custom_target(vinyl-blue-light.xpi
    COMMAND cd vinyl-blue-light
        && zip -r -FS ../vinyl-blue-light.xpi * --exclude '*.git*'
    DEPENDS vinyl-blue-light
)
add_custom_target(extensions ALL
    DEPENDS vinyl-blue-dark.xpi vinyl-blue-light.xpi
)

install(FILES
        ${CMAKE_BINARY_DIR}/vinyl-blue-dark.xpi
        ${CMAKE_BINARY_DIR}/vinyl-blue-light.xpi
    DESTINATION .
)
