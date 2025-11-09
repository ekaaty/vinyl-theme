/*
    SPDX-FileCopyrightText: 2025 Christian Tosta

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls as Controls

import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Rectangle {
    id: buttonGroup

    property var model
    property var i18nDomain

    property int orientation: Qt.Vertical
    property int iconSize: Kirigami.Units.iconSizes.small
    property int padding: Kirigami.Units.smallSpacing * 1.5
    property int spacing: padding

    readonly property int delegateFullSize: iconSize + (2 * padding)

    property color buttonColor: Qt.rgba(
        Kirigami.Theme.backgroundColor.r,
        Kirigami.Theme.backgroundColor.g,
        Kirigami.Theme.backgroundColor.b,
        0.25
    )
    property color borderColor: Qt.rgba(
        Kirigami.Theme.textColor.r,
        Kirigami.Theme.textColor.g,
        Kirigami.Theme.textColor.b,
        0.6
    )

    color: "transparent"

    width: buttonListView.contentWidth + (2 * padding)
    height: buttonGroup.orientation === Qt.Horizontal
        ? delegateFullSize + (2 * padding)
        : buttonListView.contentHeight + (2 * padding)

    Component {
        id: buttonDelegate

        Rectangle {
            color: buttonGroup.buttonColor
            border.color: buttonGroup.borderColor
            border.width: 1
            radius: buttonGroup.radius

            width: buttonGroup.delegateFullSize
            height: buttonGroup.delegateFullSize

            Kirigami.Icon {
                x: (parent.width - buttonGroup.iconSize) / 2
                y: (parent.height - buttonGroup.iconSize) / 2
                width: buttonGroup.iconSize
                height: buttonGroup.iconSize
                color: Kirigami.Theme.textColor
                source: icon
            }

            Kirigami.Heading {
                id: buttonTooltip
                font.pointSize: 8

                text: i18nd(i18nDomain, description)
                textFormat: Text.RichText

                background: Rectangle {
                    color: Qt.rgba (
                        Kirigami.Theme.backgroundColor.r,
                        Kirigami.Theme.backgroundColor.g,
                        Kirigami.Theme.backgroundColor.b,
                        0.8
                    )
                }

                width: implicitWidth + (2 * buttonGroup.padding)
                height: implicitHeight + (2 * buttonGroup.padding)

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                y: -1 * (height + buttonGroup.padding)
                z: 10

                visible: false
            }

            MouseArea {
                hoverEnabled: true
                x: 0; y: 0
                width: parent.width
                height: parent.height
                cursorShape: Qt.PointingHandCursor

                onEntered: {
                    parent.color = Qt.color(Kirigami.Theme.highlightColor)
                    parent.border.color = Qt.color(Kirigami.Theme.highlightColor)
                    buttonTooltip.visible = true
                }
                onExited: {
                    parent.color = Qt.color(buttonGroup.buttonColor)
                    parent.border.color = Qt.color(buttonGroup.borderColor)
                    buttonTooltip.visible = false
                }
                onClicked: {
			        root.dbusAsyncCall(service, path, member)
                }
            }
        }
    }

    ListView {
        id: buttonListView
        delegate: buttonDelegate
        model: parent.model
        orientation: buttonGroup.orientation
        spacing: buttonGroup.spacing

        width: buttonGroup.orientation === Qt.Horizontal
            ? contentWidth
            : parent.width - (2 * buttonGroup.padding)

        height: buttonGroup.orientation === Qt.Vertical
            ? contentHeight
            : parent.height - (2 * buttonGroup.padding)

        x: padding
        y: padding
    }
}
