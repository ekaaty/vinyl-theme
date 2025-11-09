/*
    SPDX-FileCopyrightText: 2025 Christian Tosta

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.coreaddons as KCoreAddons
import Qt5Compat.GraphicalEffects

RowLayout {
    id: avatarRoot
    Layout.fillWidth: true

    spacing: Kirigami.Units.largeSpacing
    property int size: Kirigami.Units.iconSizes.large

    KCoreAddons.KUser { id: kuser }

    Item { // User picture
        id: avatarPicture
        width: avatarRoot.size
        height: avatarRoot.size

        Rectangle {
            id: avatarMask
            width: height
            height: parent.height * 0.75
            radius: height/2
            visible: false
        }

        Image {
            id: avatarIcon
            cache: false
            source: kuser.faceIconUrl
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            fillMode: Image.PreserveAspectFit
            visible: (source !== "") ? true : false
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: avatarMask
            }
        }
    }

    ColumnLayout { // User information data
        id: avatarUserInfo
        Layout.fillWidth: true

        Kirigami.Heading {
            text: kuser.fullName
            Layout.fillWidth: true
            elide: Text.ElideRight
            maximumLineCount: 1
            font.pointSize: 13
            font.weight: 600
            level: 1
        }

        Kirigami.Heading {
            text: kuser.loginName
            Layout.fillWidth: true
            elide: Text.ElideRight
            maximumLineCount: 1
            level: 5
        }
    }

    MouseArea {
        anchors.fill: parent // FIX-ME
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            executable.exec("xdg-open systemsettings://kcm_users");
        }
    }
}
