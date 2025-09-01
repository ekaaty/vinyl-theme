add_library(vinylcommon${QT_MAJOR_VERSION} OBJECT vinylboxshadowrenderer.cpp)

set_target_properties(vinylcommon${QT_MAJOR_VERSION} PROPERTIES POSITION_INDEPENDENT_CODE TRUE)

target_link_libraries(vinylcommon${QT_MAJOR_VERSION}
    PUBLIC
        Qt${QT_MAJOR_VERSION}::Core
        Qt${QT_MAJOR_VERSION}::Gui)
