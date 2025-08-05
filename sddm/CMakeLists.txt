cmake_minimum_required(VERSION 3.16)
set(VINYL_SDDM_THEME_ID "com.ekaaty.vinyl-sddm")

if( CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR )
  project(vinyl-sddm)
  string(TIMESTAMP PROJECT_VERSION "%Y%m%d")
  set(SourceFiles
    "${CMAKE_SOURCE_DIR}/cmake"
    "${CMAKE_SOURCE_DIR}/CMakeLists.txt"
    "${CMAKE_SOURCE_DIR}/po"
    "${CMAKE_SOURCE_DIR}/src"
  )

  set(KDE_COMPILERSETTINGS_LEVEL "5.82")
  set(KF6_MIN_VERSION "6.14.0")
  set(PLASMA_MIN_VERSION "6.4.0")
  set(QT_MIN_VERSION "6.8.0")

  include(cmake/CPackLists.cmake)
else()
  # We are building as part of Main project
endif()

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED CONFIG COMPONENTS 
  Core 
  Core5Compat 
  Quick 
  QuickControls2 
  QuickLayouts
)

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS 
  Config 
  DocTools 
  I18n 
)

find_package(Plasma ${PLASMA_MIN_VERSION} REQUIRED)

set(KDE_INSTALL_LOCALEDIR share/locale)
add_definitions(-DTRANSLATION_DOMAIN=\"sddm_theme_${VINYL_SDDM_THEME_ID}\")
kdoctools_install(po)
ki18n_install(po)

install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/
	DESTINATION ${VINYL_SDDM_THEME_ID}/
)
