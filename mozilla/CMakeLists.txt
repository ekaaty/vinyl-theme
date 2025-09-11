cmake_minimum_required(VERSION 3.16)

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/.env ENV_FILE)
foreach(VAR ${ENV_FILE})
    string(REGEX MATCH "^[^=]*" KEY ${VAR})
    string(REGEX REPLACE "^[^=]*=" "" VALUE ${VAR})
    if(NOT DEFINED ${KEY})
        set(${KEY} ${VALUE})
    endif()
endforeach()

execute_process(
    COMMAND bash -c
        "date +%y.%1m.%1d -d \"$(git log -n 1 --pretty=format:%cD 2>/dev/null)\""
    OUTPUT_VARIABLE PROJECT_DATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    project(vinyl-mozilla)
    set(PROJECT_VERSION "${PLASMA_VERSION}.${PROJECT_DATE}")

    include(cmake/CPackLists.cmake)
else()
    # We are building as part of Main project
endif()

execute_process(
    COMMAND sed -i
        "s/\\(.*\"version\".*\\):.*/\\1: \"${PROJECT_VERSION}\",/g"
        ${CMAKE_CURRENT_SOURCE_DIR}/src/vinyl-blue-dark/manifest.json
        ${CMAKE_CURRENT_SOURCE_DIR}/src/vinyl-blue-light/manifest.json
)

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

# vim: ts=4:sw=4:sts=4:et
