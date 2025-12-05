/*
    SPDX-FileCopyrightText: 2024-2025 Christian Tosta

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

Item {
    id: root

    readonly property var screenGeometry: plasmoid.screenGeometry
    readonly property bool inPanel: (
        plasmoid.location == PlasmaCore.Types.TopEdge
        || plasmoid.location == PlasmaCore.Types.RightEdge
        || plasmoid.location == PlasmaCore.Types.BottomEdge
        || plasmoid.location == PlasmaCore.Types.LeftEdge
    )
    readonly property bool vertical: (
        plasmoid.formFactor == PlasmaCore.Types.Vertical
    )
    readonly property bool useCustomButtonImage: (
        Plasmoid.configuration.useCustomButtonImage
        && Plasmoid.configuration.customButtonImage.length != 0
    )
    property var appLauncher: null
    property string menuStyle: Plasmoid.configuration.menuStyle
    readonly property var menuSources: [
        "VinylMenuLauncher.qml", // menuStyle = 0 (Fallback)
        "DashBoardLauncher.qml", // menuStyle = 1
    ]

    function loadAppLauncher() {
        var menuIndex = (
                root.menuStyle < 0 ||
                root.menuStyle >= root.menuSources.length
            ) ? 0 : root.menuStyle

        var componentPath = root.menuSources[menuIndex];
        var component = Qt.createComponent(componentPath);

        if (component.status === Component.Ready) {
            if (root.appLauncher !== null) {
                root.appLauncher.destroy();
            }
            root.appLauncher = null;
            root.appLauncher = component.createObject(root);
        } else if (component.status === Component.Error) {
            console.error("Error loading component:", component.errorString());
        }
    }

    onMenuStyleChanged: loadAppLauncher()

    Plasmoid.status: appLauncher && appLauncher.visible
        ? PlasmaCore.Types.RequiresAttentionStatus
        : PlasmaCore.Types.PassiveStatus

    Kirigami.Icon {
        id: buttonIcon

        anchors.fill: parent
        source: useCustomButtonImage
            ? Plasmoid.configuration.customButtonImage
            : Plasmoid.configuration.icon
        active: mouseArea.containsMouse
        smooth: true
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            appLauncher.visible = !appLauncher.visible;
            plasmoid.expanded = appLauncher.visible;
        }
    }

    Component.onCompleted: {
        loadAppLauncher();
        plasmoid.activated.connect(function() {
            appLauncher.visible = !appLauncher.visible;
            plasmoid.expanded = appLauncher.visible;
        });
    }
}

// vim: ts=2:sw=2:sts=2:et
