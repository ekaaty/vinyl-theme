/*
    SPDX-FileCopyrightText: 2014 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2015 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2021 Ademir (Adhe) <adhemarks@gmail.com>
    SPDX-FileCopyrightText: 2024 Adolpho (ZayronXIO) <zayronxio@gmail.com>
    SPDX-FileCopyrightText: 2024-2025 Christian Tosta

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.draganddrop as DragDrop
import org.kde.iconthemes as KIconThemes
import org.kde.kcmutils as KCMUtils
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

KCMUtils.SimpleKCM {
    id: configGeneral
    
    property string i18nDomain: "plasma_applet_com.ekaaty.vinyl-launcher"

    property string cfg_icon: plasmoid.configuration.icon
    property bool cfg_useCustomButtonImage: plasmoid.configuration.useCustomButtonImage
    property string cfg_customButtonImage: plasmoid.configuration.customButtonImage
    property alias cfg_numberColumns: numberColumns.value
    property alias cfg_numberRows: numberRows.value
    property alias cfg_showFavoritesFirst: showFavoritesFirst.checked
    property alias cfg_displayPosition: displayPosition.currentIndex
    property alias cfg_gridIconSize: gridIconSize.currentIndex

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        Button {
            id: iconButton

            Kirigami.FormData.label: i18nd(i18nDomain,"Icon")

            implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
            implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2

            // Just to provide some visual feedback when dragging;
            // cannot have checked without checkable enabled
            checkable: true
            checked: dropArea.containsAcceptableDrag

            onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

            DragDrop.DropArea {
                id: dropArea

                property bool containsAcceptableDrag: false

                anchors.fill: parent

                onDragEnter: event => {
                    // Cannot use string operations (e.g. indexOf()) on "url" basic type.
                    const urlString = event.mimeData.url.toString();

                    // This list is also hardcoded in KIconDialog.
                    const extensions = [".png", ".xpm", ".svg", ".svgz"];
                    containsAcceptableDrag = urlString.indexOf("file:///") === 0
                        && extensions.some(function (extension) {
                            return urlString.indexOf(extension) === urlString.length - extension.length; // "endsWith"
                    });

                    if (!containsAcceptableDrag) {
                        event.ignore();
                    }
                }

                onDragLeave: event => {
                    containsAcceptableDrag = false
                }

                onDrop: event => {
                    if (containsAcceptableDrag) {
                        // Strip file:// prefix, we already verified in onDragEnter that we have only local URLs.
                        iconDialog.setCustomButtonImage(event.mimeData.url.toString().substr("file://".length));
                    }
                    containsAcceptableDrag = false;
                }
            }

            KIconThemes.IconDialog {
                id: iconDialog

                function setCustomButtonImage(image) {
                    configGeneral.cfg_customButtonImage = image || configGeneral.cfg_icon || "start-here-kde-symbolic"
                    configGeneral.cfg_useCustomButtonImage = true;
                }

                onIconNameChanged: setCustomButtonImage(iconName);
            }

            KSvg.FrameSvgItem {
                id: previewFrame
                anchors.centerIn: parent
                imagePath: Plasmoid.location === PlasmaCore.Types.Vertical || Plasmoid.location === PlasmaCore.Types.Horizontal
                        ? "widgets/panel-background" : "widgets/background"
                width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
                height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.large
                    height: width
                    source: configGeneral.cfg_useCustomButtonImage ? configGeneral.cfg_customButtonImage : configGeneral.cfg_icon
                }
            }

            Menu {
                id: iconMenu

                // Appear below the button
                y: +parent.height

                onClosed: iconButton.checked = false;

                MenuItem {
                    text: i18nc("@item:inmenu Open icon chooser dialog", "Choose…")
                    icon.name: "document-open-folder"
                    onClicked: iconDialog.open()
                }
                MenuItem {
                    text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
                    icon.name: "edit-clear"
                    onClicked: {
                        configGeneral.cfg_icon = "start-here-kde-symbolic"
                        configGeneral.cfg_useCustomButtonImage = false
                    }
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: showFavoritesFirst
            Kirigami.FormData.label: i18nd(i18nDomain,"Show favorites first")
        }

        ComboBox {
            id: gridIconSize
            Kirigami.FormData.label: i18nd(i18nDomain,"Grid icon size")
            model: [
                i18nd(i18nDomain,"Medium"),
                i18nd(i18nDomain,"Large"),
                i18nd(i18nDomain,"Huge")
            ]
        }

        ComboBox {
            id: displayPosition
            Kirigami.FormData.label: i18nd(i18nDomain,"Menu position")
            model: [
                i18nd(i18nDomain,"Default"),
                i18nd(i18nDomain,"Center"),
            ]
        }

        SpinBox {
            id: numberColumns
            Kirigami.FormData.label: i18nd(i18nDomain,"Number of columns")
            from: 3
            to: 5
        }

        SpinBox {
            id: numberRows
            Kirigami.FormData.label: i18nd(i18nDomain,"Number of rows")
            from: 3
            to: 5
        }

    }
}
