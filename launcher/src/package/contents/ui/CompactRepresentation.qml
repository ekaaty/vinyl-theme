/*
 * SPDX-FileCopyrightText: 2024 Christian Tosta [Github](https://ur.link/tosta)
 * SPDX-FileCopyrightText: 2013-2015 Eike Hein <hein@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
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
    property QtObject dashWindow: null

    Plasmoid.status: dashWindow && dashWindow.visible
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

    MouseArea
    {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            dashWindow.visible = !dashWindow.visible;
        }
    }

    Component.onCompleted: {
        dashWindow = Qt.createQmlObject("MenuRepresentation {}", root);
        plasmoid.activated.connect(function() {
            dashWindow.visible = !dashWindow.visible;
        });
    }
}
