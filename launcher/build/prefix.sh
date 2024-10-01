export PATH=/usr/bin:$PATH

# LD_LIBRARY_PATH only needed if you are building without rpath
# export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH

export XDG_DATA_DIRS=/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}
export XDG_CONFIG_DIRS=/usr/etc/xdg:${XDG_CONFIG_DIRS:-/etc/xdg}

export QT_PLUGIN_PATH=/usr/lib64/qt6/plugins:$QT_PLUGIN_PATH
export QML2_IMPORT_PATH=/usr/lib64/qt6/qml:$QML2_IMPORT_PATH

export QT_QUICK_CONTROLS_STYLE_PATH=/usr/lib64/qt6/qml/QtQuick/Controls.2/:$QT_QUICK_CONTROLS_STYLE_PATH

export MANPATH=/usr/share/man:${MANPATH:-/usr/local/share/man:/usr/share/man}

export SASL_PATH=/usr/lib64/sasl2:${SASL_PATH:-/usr/lib64/sasl2}
