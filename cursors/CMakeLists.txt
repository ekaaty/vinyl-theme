cmake_minimum_required(VERSION 3.16)

if( CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR )
project(vinyl-cursors)
set(WITH_BDIST ON)
else()
# We are building as part of Main project
set(WITH_BDIST OFF)
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH}  ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS Core)
include(KDEInstallDirs6)

add_custom_command( OUTPUT
                        ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-Black
                        ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-White
                    COMMAND make -C ${CMAKE_CURRENT_SOURCE_DIR} -j1 -f Makefile.build
)

add_custom_target( cursor-themes
                   ALL make -C ${CMAKE_CURRENT_SOURCE_DIR} -j1 -f Makefile.build black white clean
                   DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-Black
                   DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-White
)

if(WITH_BDIST)
add_custom_target( bdist
                   ALL COMMAND tar cfvJ
                       ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-cursors-`date +%Y%m%d`.tar.xz
                       -C ${CMAKE_CURRENT_SOURCE_DIR} Vinyl-Black/ Vinyl-White/
                   DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-Black
                   DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Vinyl-White
)
add_dependencies(bdist, themes)
endif()

install( DIRECTORY Vinyl-Black/
         DESTINATION ${KDE_INSTALL_DATADIR}/icons/Vinyl-Black/
)

install( DIRECTORY Vinyl-White/
         DESTINATION ${KDE_INSTALL_DATADIR}/icons/Vinyl-White/
)
