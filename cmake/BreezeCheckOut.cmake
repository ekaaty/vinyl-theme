# @file BreezeCheckOut.cmake
# @brief Checkout a Git Breeze branch to a local cache.
#
# SPDX-FileCopyrightText: 2026 Christian Tosta
# SPDX-License-Identifier: BSD-3-Clause

set(BREEZE_REPOSITORY "https://invent.kde.org/plasma/breeze.git")
set(BREEZE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/.cache/breeze")
set(BREEZE_GIT_SPARSE_DIRS "libbreezecommon kdecoration kstyle")

if(NOT BREEZE_COMMIT_HASH)
    set(BREEZE_COMMIT_HASH "master")
endif()

function(breeze_version)
    file(READ "${BREEZE_SOURCE_DIR}/CMakeLists.txt" _BREEZE_CONTENT)
    string(REGEX MATCH "set\\(PROJECT_VERSION \"([0-9.]+)\"\\)" _VERSION_MATCH "${_BREEZE_CONTENT}")

    if(CMAKE_MATCH_1)
        set(BREEZE_VERSION "${CMAKE_MATCH_1}" CACHE INTERNAL "Detected Breeze version")
    else()
        set(BREEZE_VERSION "0.0.0" CACHE INTERNAL "Breeze version not found")
    endif()

    if(PARENT_SCOPE)
        set(BREEZE_VERSION "${BREEZE_VERSION}" PARENT_SCOPE)
    endif()
endfunction()

if(NOT DEFINED BREEZE_FETCH_DONE)
    message(CHECK_START "Looking for Breeze sources")

    if(NOT EXISTS "${BREEZE_SOURCE_DIR}")
        file(MAKE_DIRECTORY "${BREEZE_SOURCE_DIR}")
    endif()

    set(BREEZE_FETCH_SCRIPT "
        if [ ! -d .git ]; then
            git init -q && \
            git remote add origin ${BREEZE_REPOSITORY} && \
            git config advice.detachedHead false && \
            git sparse-checkout init --cone && \
            git sparse-checkout set ${BREEZE_GIT_SPARSE_DIRS}
        fi && \
        CURRENT_HASH=$(git rev-parse HEAD 2>/dev/null)
        if [ \"$CURRENT_HASH\" != \"${BREEZE_COMMIT_HASH}\" ]; then
            git fetch --depth 1 origin ${BREEZE_COMMIT_HASH} && \
            git checkout FETCH_HEAD && \
            CURRENT_HASH=$(git rev-parse HEAD 2>/dev/null)
        fi
        echo -ne \"git commit: $CURRENT_HASH\"
    ")

    execute_process(
        COMMAND sh -c "${BREEZE_FETCH_SCRIPT}"
        WORKING_DIRECTORY "${BREEZE_SOURCE_DIR}"
        RESULT_VARIABLE BREEZE_FETCH_RESULT
        OUTPUT_VARIABLE BREEZE_FETCH_OUTPUT
        ERROR_VARIABLE BREEZE_FETCH_ERROR
    )

    # Breeze sources not found
    if(NOT BREEZE_FETCH_RESULT EQUAL 0)
        message(FATAL_ERROR "Breeze sync failed: ${BREEZE_FETCH_ERROR}")
    endif()

    breeze_version()
    set(BREEZE_FETCH_DONE TRUE CACHE INTERNAL "Breeze download status")
    message(CHECK_PASS "found version \"${BREEZE_VERSION}\" (${BREEZE_FETCH_OUTPUT})")
endif()

# Extract dependencies versions from CMakeLists.txt
if(BREEZE_FETCH_DONE)
    file(READ "${BREEZE_SOURCE_DIR}/CMakeLists.txt" _BREEZE_CONTENT)

    set(_VARS_TO_EXTRACT
        "KDE_COMPILERSETTINGS_LEVEL"
        "KF5_MIN_VERSION" "KF6_MIN_VERSION"
        "QT5_MIN_VERSION" "QT_MIN_VERSION"
    )

    foreach(_VAR ${_VARS_TO_EXTRACT})
        string(REGEX MATCH "set\\(${_VAR} \"?([0-9.]+)\"?\\)" _MATCH "${_BREEZE_CONTENT}")

        if(CMAKE_MATCH_1)
            set(${_VAR} "${CMAKE_MATCH_1}" CACHE INTERNAL "Variable matched")
            message(" * Detected requirement: ${_VAR} = ${CMAKE_MATCH_1}")
        else()
            set(${_VAR} "NOTFOUND" CACHE INTERNAL "Variable not matched")
        endif()

        if(PARENT_SCOPE)
            set(${_VAR} ${_VAR} PARENT_SCOPE)
        endif()
    endforeach()
endif()
