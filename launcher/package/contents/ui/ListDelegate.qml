/*
 * SPDX-FileCopyrightText: 2024 Christian Tosta [Github](https://ur.link/tosta)
 * SPDX-FileCopyrightText: 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.core as PlasmaCore

PlasmaComponents3.ItemDelegate {
    id: item

    Layout.fillWidth: true

    property alias subText: sublabel.text
    property alias iconItem: iconItem.children

    highlighted: activeFocus

    Accessible.name: `${text}${subText ? `: ${subText}` : ""}`

    onHoveredChanged: if (hovered) {
        if (ListView.view) {
            ListView.view.currentIndex = index;
        }
        forceActiveFocus();
    }

    contentItem: RowLayout {
        id: row

        spacing: Kirigami.Units.smallSpacing

        Item {
            id: iconItem

            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
            Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
            Layout.minimumWidth: Layout.preferredWidth
            Layout.maximumWidth: Layout.preferredWidth
            Layout.minimumHeight: Layout.preferredHeight
            Layout.maximumHeight: Layout.preferredHeight
        }

        ColumnLayout {
            id: column
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents3.Label {
                id: label
                Layout.fillWidth: true
                text: item.text
                textFormat: Text.PlainText
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }

            PlasmaComponents3.Label {
                id: sublabel
                Layout.fillWidth: true
                textFormat: Text.PlainText
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                opacity: 0.6
                font: Kirigami.Theme.smallFont
                visible: text !== ""
            }
        }
    }
}
