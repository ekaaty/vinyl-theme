################# dependencies #################
### Qt/KDE
find_package(Qt${QT_MAJOR_VERSION} REQUIRED CONFIG COMPONENTS Widgets)

################# vinylstyle target #################
set(vinylcommon_LIB_SRCS
    vinylboxshadowrenderer.cpp
)

add_library(vinylcommon${QT_MAJOR_VERSION} ${vinylcommon_LIB_SRCS})

generate_export_header(vinylcommon${QT_MAJOR_VERSION}
    BASE_NAME vinylcommon
    EXPORT_FILE_NAME vinylcommon_export.h)

target_link_libraries(vinylcommon${QT_MAJOR_VERSION}
    PUBLIC
        Qt::Core
        Qt::Gui)

set_target_properties(vinylcommon${QT_MAJOR_VERSION} PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR})


install(TARGETS vinylcommon${QT_MAJOR_VERSION} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS} LIBRARY NAMELINK_SKIP)
