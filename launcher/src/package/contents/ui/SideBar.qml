/*
    SPDX-FileCopyrightText: 2025 Christian Tosta

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

ColumnLayout {
    id: sidebarRoot
    Layout.margins: Kirigami.Units.largeSpacing
    Layout.leftMargin: Kirigami.Units.largeSpacing * 2.5

    property alias shortcutsI18nDomain: sidebarRoot.shortcutsI18nDomainValue
    property string shortcutsI18nDomainValue: "xdg-user-dirs"

    ListModel { // Sidebar data model
        id: sidebarModel
        ListElement {
            type: "place"
            label: "Documents"
            icon: "folder-documents-symbolic"
            command: "xdg-open $(xdg-user-dir DOCUMENTS)"
        }
        ListElement {
            type: "place"
            label: "Downloads"
            icon: "folder-downloads-symbolic"
            command: "xdg-open $(xdg-user-dir DOWNLOAD)"
        }
        ListElement {
            type: "place"
            label: "Music"
            icon: "folder-music-symbolic"
            command: "xdg-open $(xdg-user-dir MUSIC)"
        }
        ListElement {
            type: "place"
            label: "Pictures"
            icon: "folder-pictures-symbolic"
            command: "xdg-open $(xdg-user-dir PICTURES)"
        }
        ListElement {
            type: "place"
            label: "Videos"
            icon: "folder-videos-symbolic"
            command: "xdg-open $(xdg-user-dir VIDEOS)"
        }
        ListElement {
            type: "separator"
        }
        ListElement {
            type: "shortcut"
            label: QT_TR_NOOP("Settings")
            icon: "applications-system-symbolic"
            command: "xdg-open systemsettings://"
        }
        ListElement {
            type: "shortcut"
            label: QT_TR_NOOP("Personalization")
            icon: "preferences-desktop-theme-global-symbolic"
            command: "xdg-open systemsettings://kcm_lookandfeel"
        }
        ListElement {
            type: "shortcut"
            label: QT_TR_NOOP("Printers")
            icon: "printer-symbolic"
            command: "xdg-open systemsettings://kcm_printer_manager"
        }
        ListElement {
            type: "shortcut"
            label: QT_TR_NOOP("Update Software")
            icon: "system-software-update-symbolic"
            command: "plasma-discover --mode update"
        }
        ListElement {
            type: "shortcut"
            label: QT_TR_NOOP("Help and Support")
            icon: "help-contents"
            command: "xdg-open https://discuss.kde.org/?source=vinyl-launcher"
        }
        ListElement {
            type: "shortcut"
            label: QT_TR_NOOP("About this System")
            icon: "showinfo"
            command: "xdg-open systemsettings://kcm_about-distro"
        }
    }

    Component { // Sidebar items
        id: itemDelegate

        Item {
            // Explicitly receive the model data
            property var itemModel: null
            property real itemWidth: 0
            property int itemIconSize: Kirigami.Units.iconSizes.small * 1.5
            width: parent.width
            height: itemIconSize * 1.2

            RowLayout {
                id: listItem
                //anchors.fill: parent
                spacing: Kirigami.Units.largeSpacing

                Kirigami.Icon {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: itemIconSize
                    Layout.preferredWidth: itemIconSize
                    color: Kirigami.Theme.textColor
                    source: itemModel.icon
                }

                Kirigami.Heading {
                    text: (itemModel.label !== "")
                            ? i18nd(itemModel.type === "place"
                                ? "xdg-user-dirs"
                                : sidebarRoot.shortcutsI18nDomain,
                            itemModel.label)
                        : ""
                    Layout.fillWidth: true
                    color: Kirigami.Theme.textColor
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    level: 5
                }
            }

            MouseArea {
                anchors.fill: listItem
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    executable.exec(itemModel.command);
                }
            }
        }
    }

    Component { // Sidebar separator
        id: separatorDelegate

        Rectangle {
            property real itemWidth: 0
            width: parent.width
            height: Kirigami.Units.gridUnit * 1.5
            color: "transparent"

            Rectangle {
                color: Kirigami.Theme.textColor
                width: parent.width
                height: 2
                opacity: 0.05

                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    ListView { // Sidebar ListView
        id: mainListView
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: sidebarModel
        delegate: Loader {
            id: delegateLoader
            width: mainListView.width

            // Pass the model data to the loaded component
            // The model property of the Loader is automatically set by ListView
            property var itemModel: model

            sourceComponent: {
                switch (model.type) {
                    case "place":
                    case "shortcut":
                        return itemDelegate
                    case "separator":
                        return separatorDelegate
                }
                return null
            }

            // This is the crucial part:
            // The delegateLoader's 'itemModel' property is passed to the
            // component's 'itemModel' property.
            onLoaded: {
                if (item) {
                    if (model.type === "separator") {
                        item.itemWidth = mainListView.width
                    } else { // itemDelegate
                        item.itemModel = model
                        item.itemWidth = mainListView.width
                    }
                }
            }
        }
    }
}
