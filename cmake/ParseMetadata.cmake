# @file ParseMetadata.cmake
# @brief Parse metadata.json and define top-level PACKAGE_* CMake variables.
#
# SPDX-FileCopyrightText: 2026 Christian Tosta
# SPDX-License-Identifier: BSD-3-Clause

# Read metadata.json from project source root
# =============================================================================
if(NOT DEFINED PACKAGE)
    if(NOT DEFINED METADATA_JSON)
        file(READ "${CMAKE_CURRENT_SOURCE_DIR}/metadata.json" METADATA_JSON)
    endif()
    string(JSON PACKAGE GET "${METADATA_JSON}" "package")
endif()

# Extract core package metadata
# =============================================================================
string(JSON PACKAGE GET "${METADATA_JSON}" "package")

string(JSON PACKAGE_NAME    GET "${PACKAGE}" "name")
string(JSON PACKAGE_VERSION GET "${PACKAGE}" "version")
string(JSON PACKAGE_RELEASE GET "${PACKAGE}" "release")
string(JSON PACKAGE_ARCH    GET "${PACKAGE}" "arch")
string(JSON PACKAGE_SUMMARY GET "${PACKAGE}" "summary")
string(JSON PACKAGE_LICENSE GET "${PACKAGE}" "license")
string(JSON PACKAGE_URL     GET "${PACKAGE}" "url")
string(JSON PACKAGE_VENDOR  GET "${PACKAGE}" "vendor")

# Extract and construct long description
string(JSON DESC_LEN LENGTH "${PACKAGE}" "description")
math(EXPR LAST_DESC_IDX "${DESC_LEN} - 1")
set(PACKAGE_DESCRIPTION "")
foreach(IDX RANGE ${LAST_DESC_IDX})
    string(JSON DESC_LINE GET "${PACKAGE}" "description" ${IDX})
    string(CONCAT PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}" "${DESC_LINE} ")
endforeach()
string(STRIP "${PACKAGE_DESCRIPTION}" PACKAGE_DESCRIPTION)

# vim: ts=4:sw=4:sts=4:et:syntax=cmake
