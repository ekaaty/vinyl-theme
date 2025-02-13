/*
 * SPDX-FileCopyrightText: 2024 Christian Tosta [Github](https://ur.link/tosta)
 * SPDX-FileCopyrightText: 2013-2015 Eike Hein <hein@kde.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects // still needed ?

import org.kde.coreaddons as KCoreAddons // kuser
import org.kde.kirigami as Kirigami
//import org.kde.kquickcontrolsaddons
import org.kde.ksvg as KSvg
import org.kde.kcmutils as KCMUtils
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.plasma.private.kicker as Kicker
import org.kde.plasma.private.quicklaunch
import org.kde.plasma.private.sessions as Sessions
import org.kde.plasma.plasma5support as P5Support


Item {
    id: main

    readonly property double scaleImage: 2.5
    property int sizeImage: Kirigami.Units.iconSizes.large * scaleImage

    onVisibleChanged: {
        root.visible = !root.visible
    }

    PlasmaExtras.Menu {
        id: contextMenu

        PlasmaExtras.MenuItem {
            action: Plasmoid.internalAction("configure")
        }
    }


    PlasmaCore.Dialog { // Root Dialog
        id: root

        objectName: "popupWindow"
        flags: Qt.Dialog | Qt.FramelessWindowHint // | Qt.WindowStaysOnTopHint

        hideOnWindowDeactivate: true
        location: {
            switch(Plasmoid.configuration.displayPosition) {
                case 1: return PlasmaCore.Types.Floating;
                case 2: return PlasmaCore.Types.BottomEdge;
                default: return Plasmoid.location
            }
        }

        property int numberRows: Plasmoid.configuration.numberRows
        property int numberCols: Plasmoid.configuration.numberColumns

        property int iconSize: {
            switch(Plasmoid.configuration.appsIconSize) {
                case 0: return Kirigami.Units.iconSizes.medium;
                case 1: return Kirigami.Units.iconSizes.large;
                case 2: return Kirigami.Units.iconSizes.huge;
                default: return Kirigami.Units.iconSizes.large;
            }
        }

        property int cellHeight: iconSize + (
            2 * Math.max (highlightItemSvg.margins.top,
                          highlightItemSvg.margins.bottom) +
            Kirigami.Units.gridUnit * 2)

        property int cellWidth: iconSize + (
            2 * Math.max (highlightItemSvg.margins.left,
                          highlightItemSvg.margins.right) +
            Kirigami.Units.gridUnit * 2)

        property int sidebarWidth: 2 * (cellWidth + Kirigami.Units.gridUnit)
        property int mainGridWidth: numberCols * (cellWidth + Kirigami.Units.gridUnit)

        property int layoutFixedWidth: sidebarWidth + mainGridWidth +
            Kirigami.Units.smallSpacing
        property int layoutFixedHeight: (cellHeight * (numberRows + 1)) +
            searchField.implicitHeight + Kirigami.Units.gridUnit * 6.2

        property bool searching: (searchField.text != "")
        property bool showAllApps: !Plasmoid.configuration.showFavoritesFirst
        property bool showFavorites: Plasmoid.configuration.showFavoritesFirst

        onVisibleChanged: {
            if (visible) {
                root.showFavorites = Plasmoid.configuration.showFavoritesFirst
                root.showAllApps = !Plasmoid.configuration.showFavoritesFirst

                var pos = popupPosition(width, height);
                x = pos.x;
                y = pos.y;
                reset();
                animation1.start()
            } else {
                rootItem.opacity = 0
            }
        }

        onHeightChanged: {
            var pos = popupPosition(width, height);
            x = pos.x;
            y = pos.y;
        }

        onWidthChanged: {
            var pos = popupPosition(width, height);
            x = pos.x;
            y = pos.y;
        }

        function setModels() {
            favoritesView.model = globalFavorites
            allAppsView.model = rootModel.modelForRow(0);
        }

        function popupPosition(width, height) {
            var screenAvail = kicker.availableScreenRect;
            var screenGeom = kicker.screenGeometry;
            var screen = Qt.rect(screenAvail.x + screenGeom.x,
                                 screenAvail.y + screenGeom.y,
                                 screenAvail.width,
                                 screenAvail.height);

            var offset = Kirigami.Units.smallSpacing;

            // Fall back to bottom-left of screen area when the applet is on the desktop or floating.
            var x = offset;
            var y = screen.height - height - offset;
            var appletTopLeft;
            var horizMidPoint;
            var vertMidPoint;

            if (Plasmoid.configuration.displayPosition === 1) {
                horizMidPoint = screen.x + (screen.width / 2);
                vertMidPoint = screen.y + (screen.height / 2);
                x = horizMidPoint - width / 2;
                y = vertMidPoint - height / 2;
            } else if (Plasmoid.configuration.displayPosition === 2) {
                horizMidPoint = screen.x + (screen.width / 2);
                vertMidPoint = screen.y + (screen.height / 2);
                x = horizMidPoint - width / 2;
                y = screen.y + screen.height - height - offset - panelSvg.margins.top;
            } else if (Plasmoid.location === PlasmaCore.Types.BottomEdge) {
                horizMidPoint = screen.x + (screen.width / 2);
                appletTopLeft = parent.mapToGlobal(0, 0);
                x = (appletTopLeft.x < horizMidPoint) ? screen.x + offset : (screen.x + screen.width) - width - offset;
                y = screen.y + screen.height - height - offset - panelSvg.margins.top;
            } else if (Plasmoid.location === PlasmaCore.Types.TopEdge) {
                horizMidPoint = screen.x + (screen.width / 2);
                var appletBottomLeft = parent.mapToGlobal(0, parent.height);
                x = (appletBottomLeft.x < horizMidPoint) ? screen.x + offset : (screen.x + screen.width) - width - offset;
                //y = screen.y + parent.height + panelSvg.margins.bottom + offset;
                y = screen.y + panelSvg.margins.bottom + offset;
            } else if (Plasmoid.location === PlasmaCore.Types.LeftEdge) {
                vertMidPoint = screen.y + (screen.height / 2);
                appletTopLeft = parent.mapToGlobal(0, 0);
                x = appletTopLeft.x*2 + parent.width + panelSvg.margins.right + offset;
                y = screen.y + (appletTopLeft.y < vertMidPoint) ? screen.y + offset : (screen.y + screen.height) - height - offset;
            } else if (Plasmoid.location === PlasmaCore.Types.RightEdge) {
                vertMidPoint = screen.y + (screen.height / 2);
                appletTopLeft = parent.mapToGlobal(0, 0);
                x = appletTopLeft.x - panelSvg.margins.left - offset - width;
                y = screen.y + (appletTopLeft.y < vertMidPoint) ? screen.y + offset : (screen.y + screen.height) - height - offset;
            }
            return Qt.point(x, y);
        }

        function toggle() {
            main.visible =  !main.visible
        }

        function reset() {
            searchField.text = "";
            favoritesView.tryActivate(0,0)
        }


        FocusScope {
            id: rootItem
            focus: true

            Layout.minimumWidth: root.layoutFixedWidth
            Layout.maximumWidth: root.layoutFixedWidth
            Layout.minimumHeight: root.layoutFixedHeight
            Layout.maximumHeight: root.layoutFixedHeight

            Logic { id: logic }

            OpacityAnimator {
                id: animation1;
                target: rootItem;
                from: 0;
                to: 1;
                easing.type: Easing.InOutQuad;
            }

            // TODO: Migrate to javascript function with formal parameters
            P5Support.DataSource {
                id: executable
                engine: "executable"
                connectedSources: []
                onNewData: {
                    var exitCode = data["exit code"]
                    var exitStatus = data["exit status"]
                    var stdout = data["stdout"]
                    var stderr = data["stderr"]
                    exited(sourceName, exitCode, exitStatus, stdout, stderr)
                    disconnectSource(sourceName)
                }
                function exec(cmd) {
                    if (cmd) {
                        connectSource(cmd)
                    }
                }
                signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
            }






            GridLayout { // Main Grid
                id: mainGrid
                columns: 2

                /* -- Sidebar -------------------------------------------------------- */
                ColumnLayout { // Sidebar
                    id: sidebar

                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.margins: Kirigami.Units.smallSpacing
                    Layout.topMargin: Kirigami.Units.largeSpacing
                    Layout.maximumWidth: root.sidebarWidth
                    Layout.minimumWidth: root.sidebarWidth

                    height: root.layoutFixedHeight
                    width: root.sidebarWidth

                    KCoreAddons.KUser { id: kuser }

                    RowLayout { // User information

                        Column { // User avatar - TODO: Use Avatar class
                            Layout.rightMargin: Kirigami.Units.largeSpacing

                            Rectangle {
                                id: maskavatar
                                height: parent.height * 0.75
                                width: height
                                radius: height/2
                                visible: false
                            }

                            Image {
                                id: iconUser
                                source: kuser.faceIconUrl
                                sourceSize.width: Kirigami.Units.iconSizes.large
                                sourceSize.height: Kirigami.Units.iconSizes.large
                                fillMode: Image.PreserveAspectFit
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: maskavatar
                                }
                                visible: (source !== "") ? true : false
                            }
                        }

                        Column { // User information data

                            QtObject {
                                id: __font

                                function size(obj) {
                                    switch(obj.level) {
                                        case 1: return 11;
                                        case 2: return 10;
                                        case 3: return 9;
                                        default: return 8;
                                    }
                                }

                                property int normal: 400
                                property int semiBold: 500
                                property int bold: 600
                            }

                            Row {
                                Kirigami.Heading {
                                    id: userFullName
                                    //Layout.fillWidth: false
                                    font.pointSize: __font.size(this)
                                    font.weight: __font.normal
                                    color: Kirigami.Theme.textColor
                                    text: kuser.fullName
                                    level: 1
                                    wrapMode: Text.Wrap
                                    width: 2 * root.cellWidth
                                    maximumLineCount: 1
                                    elide: Text.ElideRight
                                    clip: true
                                }
                            }

                            Row {
                                Kirigami.Heading {
                                    id: userLogin
                                    Layout.fillWidth: true
                                    font.pointSize: __font.size(this)
                                    font.weight: __font.normal
                                    color: Kirigami.Theme.textColor
                                    text: kuser.loginName
                                    level: 2
                                    wrapMode: Text.Wrap
                                    width: 2 * root.cellWidth
                                    maximumLineCount: 1
                                    elide: Text.ElideRight
                                    clip: true
                                }
                            }
                        }
                    }

                    RowLayout { // User Directories
                        Layout.topMargin: 3 * Kirigami.Units.largeSpacing
                        Layout.alignment: Qt.AlignCenter
                        width: sidebar.width - Kirigami.Units.gridUnit
                        height: (root.cellHeight * root.numberRows) +
                            Kirigami.Units.gridUnit /* +
                            2 * Kirigami.Units.largeSpacing */

                        ListModel {
                            id: placeModel
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
                                label: ""
                                icon: ""
                                command: ""
                            }

                            ListElement {
                                type: "shortcut"
                                label: QT_TR_NOOP("Settings")
                                icon: "systemsettings"
                                command: "xdg-open systemsettings://"
                            }
                            ListElement {
                                type: "shortcut"
                                label: QT_TR_NOOP("Personalization")
                                icon: "preferences-desktop-theme-global"
                                command: "xdg-open systemsettings://kcm_colors"
                            }
                            ListElement {
                                type: "shortcut"
                                label: QT_TR_NOOP("Devices and Printers")
                                icon: "preferences-devices-printer"
                                command: "xdg-open systemsettings://kcm_printer_manager"
                            }
                            ListElement {
                                type: "shortcut"
                                label: QT_TR_NOOP("Update Software")
                                icon: "software-updates-updates"
                                command: "plasma-discover --mode update"
                            }
                            ListElement {
                                type: "shortcut"
                                label: QT_TR_NOOP("Help and Support")
                                icon: "system-help"
                                command: "xdg-open https://discuss.kde.org/?source=vinyl-launcher"
                            }
                        }

                        Component {
                            id: placeDelegate

                            Item {
                                property double lineSpacing: 2.0

                                height: Kirigami.Units.iconSizes.small * lineSpacing

                                Column {

                                    Row {

                                        Text {
                                            property var i18nDomain: (type === "place") ?
                                                "xdg-user-dirs" :
                                                "plasma_applet_com.ekaaty.vinyl-launcher"

                                            verticalAlignment: Text.AlignVCenter
                                            height: Kirigami.Units.iconSizes.small
                                            leftPadding: Kirigami.Units.iconSizes.small +
                                                Kirigami.Units.largeSpacing

                                            font.pointSize: Kirigami.Theme.defaultFont.pointSize
                                            color: Kirigami.Theme.textColor
                                            text: (label !== "") ? i18nd(i18nDomain, label) : ""

                                            Kirigami.Icon {
                                                source: model.icon
                                                height: Kirigami.Units.iconSizes.small
                                                width: Kirigami.Units.iconSizes.small
                                                color: Kirigami.Theme.textColor
                                            }

                                            MouseArea {
                                                width: parent.width
                                                height: parent.height
                                                anchors.centerIn: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    executable.exec(command);
                                                }
                                            }
                                        }

                                    }

                                }

                            }
                        }

                        Component {
                            id: lineSeparator

                            Rectangle {
                                width: parent.width
                                height: Kirigami.Units.iconSizes.small * 3
                                color: "transparent"

                                KSvg.SvgItem {
                                    anchors.verticalCenter: parent.verticalCenter
                                    imagePath: "widgets/line"
                                    elementId: "horizontal-line"
                                    width: parent.width
                                    height: 1
                                }
                            }
                        }

                        Column {
                            width: parent.width
                            height: parent.height

                            ListView {
                                id: placesView
                                width: parent.width
                                height: parent.height
                                model: placeModel
                                delegate: placeDelegate
                            }

                        }

                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                        Layout.margins: 3 * Kirigami.Units.largeSpacing
                        Layout.topMargin: root.cellHeight
                        y: 0

                        property double lineSpacing: 2.0
                        height: Kirigami.Units.iconSizes.small * lineSpacing

                        Column {
                            Row {
                                Text {
                                    verticalAlignment: Text.AlignVCenter
                                    height: Kirigami.Units.iconSizes.small
                                    leftPadding: Kirigami.Units.iconSizes.small +
                                        Kirigami.Units.largeSpacing

                                    font.pointSize: Kirigami.Theme.defaultFont.pointSize
                                    color: Kirigami.Theme.textColor
                                    text: i18nd("plasma_applet_com.ekaaty.vinyl-launcher", "Exit")

                                    Kirigami.Icon {
                                        source: "arrow-left-symbolic"
                                        height: Kirigami.Units.iconSizes.small
                                        width: Kirigami.Units.iconSizes.small
                                        color: Kirigami.Theme.textColor
                                    }

                                    /* Text {
                                        anchors.left: parent.right
                                        anchors.leftMargin: Kirigami.Units.mediumSpacing
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        //width:
                                        height: parent.height
                                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                                        color: Kirigami.Theme.textColor
                                        text: ">"
				    }*/

                                    MouseArea {
                                        width: parent.width +
                                            Kirigami.Units.mediumSpacing +
                                            Kirigami.Units.iconSizes.small
                                        height: parent.height
                                        anchors.centerIn: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            executable.exec(
                                                "qdbus-qt6 org.kde.LogoutPrompt /LogoutPrompt promptAll"
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }

                }

                /* -- Grid View ------------------------------------------------------ */
                ColumnLayout {
                    id: mainContent

                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    //Layout.margins: Kirigami.Units.largeSpacing
                    Layout.minimumWidth: root.mainGridWidth
                    Layout.maximumWidth: root.mainGridWidth

                    width: root.mainGridWidth
                    height: root.layoutFixedHeight

                    RowLayout { // Search Field
                        Layout.alignment: Qt.AlignTop | Qt.AlignCenter
                        //Layout.margins: Kirigami.Units.smallSpacing
                        //Layout.fillWidth: true

                        PlasmaComponents.TextField {
                            id: searchField

                            Layout.alignment: Qt.AlignTop | Qt.AlignCenter
                            Layout.margins: Kirigami.Units.largeSpacing
                            Layout.rightMargin: Kirigami.Units.gridUnit * 2
                            Layout.fillWidth: true

                            width: root.cellWidth * root.numberCols
                            height: parent.height

                            topPadding: Kirigami.Units.mediumSpacing
                            bottomPadding: Kirigami.Units.mediumSpacing
                            leftPadding: Kirigami.Units.iconSizes.small +
                                Kirigami.Units.largeSpacing * 2
                            rightPadding: Kirigami.Units.iconSizes.small +
                                Kirigami.Units.largeSpacing * 2

                            font.pointSize: Kirigami.Theme.defaultFont.pointSize
                            placeholderText: i18nd("plasma_applet_com.ekaaty.vinyl-launcher",
                                                "Search this computer ...")
                            text: ""

                            /*background: Rectangle {
                                Kirigami.Theme.colorSet: Kirigami.Theme.Button
                                color: Kirigami.Theme.backgroundColor
                            }*/

                            onTextChanged: {
                                runnerModel.query = text;
                            }

                            Keys.onPressed: (event)=> {
                                switch(event.key) {
                                    case Qt.Key_Escape: {
                                        event.accepted = true;
                                        root.searching ?
                                            searchField.clear() :
                                            root.toggle()
                                    }
                                    case Qt.Key_Down || Qt.Key_Tab || Qt.Key_Backtab: {
                                        event.accepted = true;
                                        root.searching ?
                                            runnerGrid.tryActivate(0,0) :
                                            favoritesView.tryActivate(0,0)
                                    }
                                }
                            }

                            function backspace() {
                                if (!root.visible) {
                                    return;
                                }
                                focus = true;
                                text = text.slice(0, -1);
                            }

                            function appendText(newText) {
                                if (!root.visible) {
                                    return;
                                }
                                focus = true;
                                text = text + newText;
                            }

                            Kirigami.Icon {
                                source: 'search'
                                anchors {
                                    left: searchField.left
                                    verticalCenter: searchField.verticalCenter
                                    //leftMargin: Kirigami.Units.smallSpacing
                                    leftMargin: Kirigami.Units.largeSpacing
                                }
                                height: Kirigami.Units.iconSizes.small
                                width: Kirigami.Units.iconSizes.small
                            }
                        }

                    }

                    GridLayout { // Runner Grid
                        id: runnerGrid
                        columns: 1

                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                        //Layout.fillWidth: true


                        PlasmaExtras.Highlight  {
                            id: delegateHighlight
                            visible: false
                            z: -1 // otherwise it shows ontop of the icon/label and tints them slightly
                        }

                        Kirigami.Heading {
                            id: dummyHeading
                            visible: false
                            width: 0
                            level: 5
                        }

                        ItemMultiGridView {
                            Layout.alignment: Qt.AlignTop | Qt.AlignCenter
                            Layout.fillWidth: false
                            width: root.mainGridWidth

                            cellWidth: root.cellWidth
                            cellHeight: root.cellHeight

                            enabled: root.searching
                            z:  enabled ? 5 : -1

                            grabFocus: true
                            onKeyNavUp: searchField.focus = true
                            model: runnerModel
                        }
                    }

                    GridLayout { // Favorites Grid
                        id: favoritesGrid
                        columns: 1

                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                        visible: !root.searching && root.showFavorites && !root.showAllApps

                        RowLayout {
                            Kirigami.Heading {
                                id: favoritesHeading

                                Layout.margins: Kirigami.Units.smallSpacing
                                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                //Layout.fillWidth: true
                                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                                font.weight: 500
                                text: i18nd("plasma_applet_com.ekaaty.vinyl-launcher", "My favorite items")
                            }
                        }

                        RowLayout {
                            Column {
                                Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                                Rectangle {
                                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                                    ItemGridView { // Favorites Icon Grid
                                        id: favoritesView

                                        anchors {
                                            topMargin: Kirigami.Units.gridUnit
                                            left: parent.left
                                        }

                                        width: root.mainGridWidth
                                        height: (root.cellHeight * root.numberRows) +
                                            Kirigami.Units.gridUnit +
                                            2 * Kirigami.Units.largeSpacing

                                        iconSize: root.iconSize

                                        dragEnabled: true
                                        dropEnabled: true
                                        focus: true

                                        onKeyNavUp: searchField.focus = true
                                        Keys.onPressed:(event)=> {
                                            if (event.modifiers & (Qt.ControlModifier || Qt.ShiftModifier)) {
                                                searchField.focus = true;
                                                return
                                            }
                                            if (event.key === Qt.Key_Tab) {
                                                event.accepted = true;
                                                searchField.focus = true
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                            Layout.topMargin: root.layoutFixedHeight -
                                root.cellHeight - Kirigami.Units.iconSizes.small -
                                (2 * Kirigami.Units.largeSpacing)

                            property double lineSpacing: 2.0
                            height: Kirigami.Units.iconSizes.small * lineSpacing

                            Column {
                                Row {
                                    Text {
                                        verticalAlignment: Text.AlignVCenter
                                        height: Kirigami.Units.iconSizes.small
                                        leftPadding: Kirigami.Units.iconSizes.small +
                                            Kirigami.Units.largeSpacing

                                        font.pointSize: Kirigami.Theme.defaultFont.pointSize
                                        color: Kirigami.Theme.textColor
                                        text: i18nd("plasma_applet_com.ekaaty.vinyl-launcher", "All Apps")

                                        Kirigami.Icon {
                                            source: "applications-all-symbolic"
                                            height: Kirigami.Units.iconSizes.small
                                            width: Kirigami.Units.iconSizes.small
                                            color: Kirigami.Theme.textColor
                                        }

                                        MouseArea {
                                            width: parent.width
                                            height: parent.height
                                            anchors.centerIn: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                root.showFavorites = false
                                                root.showAllApps = true
                                            }
                                        }
                                    }
                                }
                            }
                        }

                    }

                    GridLayout { // All Apps Grid
                        id: allAppsGrid
                        columns: 1

                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                        visible: !root.searching && root.showAllApps //&& !root.showFavorites

                        RowLayout {
                            Kirigami.Heading {
                                id: allAppsHeading

                                Layout.margins: Kirigami.Units.smallSpacing
                                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                //Layout.fillWidth: true
                                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                                font.weight: 500
                                text: i18nd("plasma_applet_com.ekaaty.vinyl-launcher", "All applications")
                            }
                        }

                        RowLayout {
                            Column {
                                Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                                Rectangle {
                                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

                                    ItemGridView {
                                        id: allAppsView

                                        anchors {
                                            topMargin: Kirigami.Units.gridUnit
                                            bottomMargin: Kirigami.Units.gridUnit
                                            left: parent.left
                                        }

                                        width: root.mainGridWidth
                                        height: (root.cellHeight * root.numberRows) +
                                            Kirigami.Units.gridUnit +
                                            2 * Kirigami.Units.largeSpacing

                                        iconSize: root.iconSize

                                        dropEnabled: false
                                        dragEnabled: false
                                        focus: true

                                        visible: parent.visible

                                        enabled: !root.searching
                                        z:  enabled ? 5 : -1

                                        onKeyNavUp: searchField.focus = true
                                    }

                                }

                            }

                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                            Layout.topMargin: root.layoutFixedHeight -
                                root.cellHeight - Kirigami.Units.iconSizes.small -
                                (2 * Kirigami.Units.largeSpacing)

                            property double lineSpacing: 2.0
                            height: Kirigami.Units.iconSizes.small * lineSpacing

                            Column {
                                Row {
                                    Text {
                                        verticalAlignment: Text.AlignVCenter
                                        height: Kirigami.Units.iconSizes.small
                                        leftPadding: Kirigami.Units.iconSizes.small +
                                            Kirigami.Units.largeSpacing

                                        font.pointSize: Kirigami.Theme.defaultFont.pointSize
                                        color: Kirigami.Theme.textColor
                                        text: i18nd("plasma_applet_com.ekaaty.vinyl-launcher", "Favorites")

                                        Kirigami.Icon {
                                            source: "emblem-favorite-symbolic"
                                            height: Kirigami.Units.iconSizes.small
                                            width: Kirigami.Units.iconSizes.small
                                            color: Kirigami.Theme.textColor
                                        }

                                        MouseArea {
                                            width: parent.width
                                            height: parent.height
                                            anchors.centerIn: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                root.showFavorites = true
                                                root.showAllApps = false
                                            }
                                        }
                                    }
                                }
                            }
                        }

                    }

                }

                /*RowLayout {
                    id: rowSystemActions

                    Layout.margins: Kirigami.Units.largeSpacing
                    Layout.maximumWidth: root.sidebarWidth
                    Layout.minimumWidth: root.sidebarWidth
                    Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                    Layout.fillWidth: true

                    PlasmaComponents.ToolButton { // Shutdown Button
                        id: btnShutdown

                        height: mainGrid.iconSmall
                        width: mainGrid.iconSmall
                        icon.name: "system-shutdown-symbolic"
                        text: i18n("Shutdown") + " >"

                        Layout.alignment: Qt.AlignLeft

                        onClicked: {}
                        ToolTip.delay: 200
                        ToolTip.timeout: 1000
                        ToolTip.visible: hovered
                        ToolTip.text: i18n("System Actions")
                    }
                }*/
            }


            Keys.onPressed: (event)=> { // Keyboard Control
                if (event.modifiers & (Qt.ControlModifier || Qt.ShiftModifier)) {
                    searchField.focus = true;
                    return
                }

                switch(event.key) {
                    case Qt.Key_Tab: {
                        event.accepted = true;
                        searchField.focus = true
                    }
                    case Qt.Key_Backspace: {
                        event.accepted = true;
                        root.searching ?
                            searchField.backspace() :
                            searchField.focus = true
                    }
                    case Qt.Key_Escape: {
                        event.accepted = true;
                        root.searching ?
                            searchField.clear() :
                        root.toggle()
                    }
                    default: {
                        event.accepted = true
                        if (event.text !== "" && event.key !== Qt.Key_Escape) {
                            event.accepted = true;
                            searchField.appendText(event.text);
                        }
                    }
                }
            }

        }

        Component.onCompleted: {
            rootModel.refreshed.connect(setModels)
            reset();
            rootModel.refresh();
        }
    }



}
