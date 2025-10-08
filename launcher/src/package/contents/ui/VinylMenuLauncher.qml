/*
    SPDX-FileCopyrightText: 2025 Christian Tosta

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid

import org.kde.plasma.private.kicker as Kicker
import org.kde.plasma.private.quicklaunch

import org.kde.plasma.plasma5support as P5Support // Needed by datasource

Item {
    id: applet

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
        flags: Qt.WindowStaysOnTopHint

        hideOnWindowDeactivate: true

        // Internationalization
        property string i18nDomain: "plasma_applet_com.ekaaty.vinyl-launcher"

        // -- GridView metrics and settings ------------------------------------
        property bool showAllApps: !Plasmoid.configuration.showFavoritesFirst
        property bool showFavorites: Plasmoid.configuration.showFavoritesFirst
        property bool searching: (searchField.text !== "")

        property int numberRows: Plasmoid.configuration.numberRows
        property int numberCols: Plasmoid.configuration.numberColumns

        property int iconSize: {
            switch(Plasmoid.configuration.appsIconSize) {
                case 0:  return Kirigami.Units.iconSizes.medium; // 32
                case 1:  return Kirigami.Units.iconSizes.large;  // 48
                case 2:  return Kirigami.Units.iconSizes.huge;   // 64
                default: return Kirigami.Units.iconSizes.large;
            }
        }

        readonly property int cellSpacing: Kirigami.Units.smallSpacing
        readonly property int scrollBarWidth: Kirigami.Units.gridUnit
        property int cellSize: iconSize < 48 ? (2.5 * iconSize) : (2 * iconSize)

        property int gridViewWidth: (cellSize * numberCols) +
                                    (cellSpacing * (numberCols - 1)) +
                                    scrollBarWidth

        // -- SideBar metrics --------------------------------------------------
        property int sidebarWidth: 240

        // -- Dialog sizing ----------------------------------------------------
        // SideBar + Contents + margins
        property int layoutFixedWidth: (sidebarWidth + gridViewWidth) +
                                       (3.5 * Kirigami.Units.largeSpacing) +
                                       (2.0 * Kirigami.Units.largeSpacing)

        // Use 2 extra columns and margins
        property int layoutFixedHeight: (cellSize * (numberRows + 2)) +
                                        (2.0 * Kirigami.Units.largeSpacing)


        // Events
        onVisibleChanged: {
            if (visible) {
                root.showFavorites = Plasmoid.configuration.showFavoritesFirst
                root.showAllApps = !Plasmoid.configuration.showFavoritesFirst
                var pos = popupPosition(width, height);
                x = pos.x;
                y = pos.y;
                reset();
                animation1.start()
                searchField.focus = true;
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

        // Methods
        function popupPosition(width, height) {
            var screenAvail = kicker.availableScreenRect;
            var screenGeom = kicker.screenGeometry;
            var screen = Qt.rect(screenAvail.x + screenGeom.x,
                                screenAvail.y + screenGeom.y,
                                screenAvail.width,
                                screenAvail.height);

            var offset = 2 * Kirigami.Units.smallSpacing;

            var appletTopLeft = parent.mapToGlobal(0, 0);
            var appletTopRight = parent.mapToGlobal(parent.width, 0);
            var appletBottomLeft = parent.mapToGlobal(0, parent.height);

            var horizMidPoint = screen.x + (screen.width / 2);

            function calculateCoordinate(appletCoord, menuSize, screenStart, screenEnd) {
                var pos = appletCoord;
                pos = Math.max(pos, screenStart + offset);
                pos = Math.min(pos, screenEnd - menuSize - offset);
                return pos;
            }

            // Fallback to bottom-left of screen
            var position = {
                x: (offset / 2),
                y: (screen.y + screen.height) - (height + offset)
            };

            switch (Plasmoid.location) {
                case PlasmaCore.Types.BottomEdge:
                    position.y = appletTopLeft.y - (height + offset);
                    position.x = calculateCoordinate(
                        appletTopLeft.x, width, screen.x, screen.x + screen.width
                    );
                    break;
                case PlasmaCore.Types.TopEdge:
                    position.y = appletBottomLeft.y + offset;
                    position.x = calculateCoordinate(
                        appletBottomLeft.x, width, screen.x, screen.x + screen.width
                    );
                    break;
                case PlasmaCore.Types.LeftEdge:
                    position.x = appletTopRight.x + offset;
                    position.y = calculateCoordinate(
                        appletTopRight.y, height, screen.y, screen.y + screen.height
                    );
                    break;
                case PlasmaCore.Types.RightEdge:
                    position.x = appletTopLeft.x - (width + offset);
                    position.y = calculateCoordinate(
                        appletTopLeft.y, height, screen.y, screen.y + screen.height
                    );
                    break;
            }

            // Centralize the menu (if it is horizontal and set in configuration)
            if (Plasmoid.configuration.displayPosition === 1
                && Plasmoid.location !== PlasmaCore.Types.LeftEdge
                && Plasmoid.location !== PlasmaCore.Types.RightEdge) {
                position.x = horizMidPoint - (width / 2);
            }

            return Qt.point(position.x, position.y);
        }

        function reset() {
            searchField.clear();
            globalFavoritesGrid.tryActivate(0,0);
        }

        function setModels() {
            globalFavoritesGrid.model = globalFavorites;
            allAppsGrid.model = rootModel.modelForRow(0);
        }

        function toggle() {
            root.visible = !root.visible;
        }

        FocusScope {
            id: rootItem
            Layout.minimumWidth:  root.layoutFixedWidth
            Layout.maximumWidth:  root.layoutFixedWidth
            Layout.minimumHeight: root.layoutFixedHeight
            Layout.maximumHeight: root.layoutFixedHeight

            focus: true

            Logic { id: logic }

            OpacityAnimator {
                id: animation1;
                target: rootItem;
                from: 0;
                to: 1;
                duration: 500;
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
                signal exited(string cmd, int exitCode, int exitStatus,
                              string stdout, string stderr)
            }

            KSvg.FrameSvgItem {
                id : headingSvg

                width: parent.height + 4
                height: root.sidebarWidth +
                        Kirigami.Units.gridUnit * 2 +
                        Kirigami.Units.largeSpacing
                x: -4
                y: width

                imagePath: "widgets/plasmoidheading"
                prefix: "header"
                opacity: 0.8
                transform: Rotation {
                    angle: -90
                    origin.x: width / 2
                    origin.y: height / 2
                }
            }

            GridLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.largeSpacing
                columns: 2

                // -- Header ---------------------------------------------------
                Avatar { id: userInfo }

                ColumnLayout { // SearchBar
                    Layout.maximumWidth: root.gridViewWidth
                    Layout.minimumWidth: root.gridViewWidth

                    Kirigami.SearchField {
                        id: searchField
                        Layout.preferredWidth: parent.width * 0.8
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        Layout.margins: 0
                        background: Rectangle {
                            color: Kirigami.Theme.backgroundColor
                            border.color: parent.focus
                                ? Kirigami.Theme.highlightColor
                                : Kirigami.Theme.disabledTextColor
                            border.width: parent.focus ? 1 : 0
                            opacity: parent.focus ? 1 : 0.25
                            radius: 4
                        }
                        activeFocusOnTab: true
                        onTextChanged: {
                            runnerModel.query = text;
                        }
                        Keys.onPressed: (event) => {
                            switch(event.key) {
                                case Qt.Key_Down:
                                case Qt.Key_Tab:
                                case Qt.Key_Backtab: {
                                    event.accepted = true;
                                    root.searching ?
                                        runnerGrid.tryActivate(0, 0) :
                                        (root.showAllApps ?
                                            allAppsGrid :
                                            globalFavoritesGrid
                                        ).tryActivate(0, 0)
                                    break;
                                }
                                case Qt.Key_Enter:
                                case Qt.Key_Return: {
                                    if (root.searching && runnerGrid.count > 0) {
                                        event.accepted = true;
                                        runnerGrid.tryActivate(0, 0);
                                        Qt.callLater(function() {
                                            var item = runnerGrid.subGridAt(0).currentItem;
                                            if (item && item.actionTriggered) {
                                                item.actionTriggered("");
                                            }
                                        });
                                    }
                                    break;
                                }
                                case Qt.Key_Escape: {
                                    if (root.searching) {
                                        event.accepted = true;
                                        searchField.clear();
                                    }
                                    break;
                                }
                                default: {
                                    event.accepted = false;
                                    break;
                                }
                            }
                        }
                    }
                }

                // -- Sidebar --------------------------------------------------
                SideBar {
                    id: sidebar
                    shortcutsI18nDomain: root.i18nDomain
                    Layout.maximumWidth: root.sidebarWidth
                    Layout.minimumWidth: root.sidebarWidth
                }

                // -- MenuGrids ------------------------------------------------
                ColumnLayout { // MenuGrids
                    id: mainContent
                    Layout.margins: Kirigami.Units.largeSpacing
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.fillHeight: true

                    ColumnLayout { // Favorites Grid
                        id: globalFavoritesGridLayout
                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                        visible: !root.searching && root.showFavorites && !root.showAllApps

                        Kirigami.Heading { // Favorite Heading
                            id: favoritesHeading
                            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                            Layout.margins: Kirigami.Units.smallSpacing
                            color: Kirigami.Theme.textColor
                            text: i18nd(root.i18nDomain, "My favorite items")
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            level: 3
                        }

                        ItemGridView { // Favorites Icon Grid
                            id: globalFavoritesGrid
                            Layout.preferredWidth: root.gridViewWidth
                            Layout.minimumWidth: root.gridViewWidth
                            Layout.fillHeight: true
                            spacing: root.cellSpacing
                            cellWidth: root.cellSize
                            cellHeight: root.cellSize
                            iconSize: root.iconSize
                            dragEnabled: true
                            dropEnabled: true
                            focus: true
                            onKeyNavUp: searchField.focus = true
                        }
                    }

                    ColumnLayout { // All Apps Grid
                        id: allAppsGridLayout
                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                        visible: !root.searching && !root.showFavorites && root.showAllApps

                        Kirigami.Heading { // all Apps Heading
                            id: allAppsHeading
                            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                            color: Kirigami.Theme.textColor
                            text: i18nd(root.i18nDomain, "All applications")
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            level: 3
                        }

                        ItemGridView { // all Apps Icon Grid
                            id: allAppsGrid
                            Layout.preferredWidth: root.gridViewWidth
                            Layout.minimumWidth: root.gridViewWidth
                            Layout.maximumHeight: root.cellSize * root.numberRows
                            Layout.fillHeight: true
                            spacing: root.cellSpacing
                            cellWidth: root.cellSize
                            cellHeight: root.cellSize
                            iconSize: root.iconSize
                            dragEnabled: true
                            dropEnabled: true
                            focus: true
                            onKeyNavUp: searchField.focus = true
                        }
                    }

                    RowLayout { // Runner Grid
                        id: runnerGridLayout

                        Kirigami.Heading {
                            id: dummyHeading
                            visible: false
                            width: 0
                            level: 5
                        }

                        ItemMultiGridView {
                            id: runnerGrid
                            Layout.preferredWidth: root.gridViewWidth
                            Layout.minimumWidth: root.gridViewWidth
                            Layout.fillHeight: true
                            numberCols: root.numberCols
                            spacing: root.cellSpacing
                            cellSize: root.cellSize
                            iconSize: root.iconSize
                            enabled: root.searching
                            z: enabled ? 5 : -1
                            grabFocus: false
                            onKeyNavUp: searchField.focus = true
                            model: runnerModel
                        }
                    }
                }

                // -- Footer ---------------------------------------------------
                ColumnLayout { // SystemActions
                    id: systemActionsLayout
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.leftMargin: Kirigami.Units.largeSpacing * 3
                    Layout.bottomMargin: Kirigami.Units.largeSpacing * 2

                    ListModel {
                        id: systemActionsModel
                        ListElement {
                            description: "Shows shutdown screen"
                            icon:    "system-shutdown"
                            command: "qdbus-qt6 org.kde.LogoutPrompt /LogoutPrompt promptAll"
                        }
                        ListElement {
                            description: "Open Krunner dialog"
                            icon:    "search"
                            command: "qdbus-qt6 org.kde.krunner /App display"
                        }
                    }

                    ButtonGroup {
                        id: systemActions
                        model: systemActionsModel
                        i18nDomain: root.i18nDomain
                        orientation: Qt.Horizontal
                        buttonColor: "transparent"
                        radius: 4

                    }
                }

                ColumnLayout { // Favorites / AllApps toggle button
                    id: otherActions
                    Layout.preferredWidth: root.gridViewWidth
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                    PlasmaComponents.Label {
                        id: toggleButton
                        Layout.alignment: Qt.AlingLeft | Qt.AlignVCenter
                        leftPadding: Kirigami.Units.iconSizes.small +
                                        Kirigami.Units.largeSpacing
                        color: Kirigami.Theme.textColor
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize

                        readonly property string favoritesString: i18nd(
                            "plasma_applet_com.ekaaty.vinyl-launcher",
                            "Favorites"
                        )
                        readonly property string allAppsString: i18nd(
                            "plasma_applet_com.ekaaty.vinyl-launcher",
                            "All Applications"
                        )

                        text: {
                            (root.showFavorites && !root.showAllApps)
                                ? allAppsString
                                : favoritesString
                        }

                        Kirigami.Icon {
                            source: {
                                (root.showFavorites && !root.showAllApps)
                                    ? "applications-all-symbolic"
                                    : "emblem-favorite-symbolic"
                            }

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
                                root.showFavorites = !root.showFavorites
                                root.showAllApps = !root.showAllApps
                                searchField.focus = true
                            }
                        }
                    }
                }

            }

            Keys.onPressed: (event) => { // Keyboard Control
                if (event.modifiers & (Qt.ControlModifier | Qt.ShiftModifier)) {
                    event.accepted = true;
                    searchField.focus = true;
                    return
                }

                switch(event.key) {
                    case Qt.Key_Escape: {
                        event.accepted = true;
                        root.toggle();
                        break;
                    }
                    case Qt.Key_Slash: {
                        event.accepted = true;
                        searchField.focus = true
                        break;
                    }
                    default: {
                        if (event.text !== "" && event.key !== Qt.Key_Escape) {
                            event.accepted = true;
                        }
                        break;
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
