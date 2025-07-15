cmake_minimum_required(VERSION 3.16)

if( CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR )
project(vinyl-sddm)
string(TIMESTAMP PROJECT_VERSION "%Y%m%d")
set(SourceFiles 
  "${CMAKE_SOURCE_DIR}/cmake"
  "${CMAKE_SOURCE_DIR}/CMakeLists.txt"
  "${CMAKE_SOURCE_DIR}/CPackLists.txt"
  "${CMAKE_SOURCE_DIR}/src"
)
include(CPackLists.txt)
else()
# We are building as part of Main project
endif()

#set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/
	DESTINATION vinyl/
)
