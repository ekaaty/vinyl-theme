/*
    SPDX-FileCopyrightText: 2013-2015 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2024-2025 Christian Tosta

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.private.kicker as Kicker

PlasmoidItem {
    id: kicker

    anchors.fill: parent

    // Signals
    signal reset
    signal modelRefreshed

    // Representations
    preferredRepresentation: compactRepresentation
    compactRepresentation: appLauncherRepresentationComponent
    fullRepresentation: appLauncherRepresentationComponent

    // Properties
    property Item dragSource: null

    property QtObject globalFavorites: rootModel.favoritesModel
    property QtObject systemFavorites: rootModel.systemFavoritesModel

    // Methods
    function resetDragSource() {
        dragSource = null;
    }

    function enableHideOnWindowDeactivate() {
        kicker.hideOnWindowDeactivate = true;
    }

    function action_menuedit() {
        processRunner.runMenuEditor();
    }

    // Events:
    /*onSystemFavoritesChanged: {
        systemFavorites.favorites = Plasmoid.configuration.favoriteSystemActions;
    }*/

    // Connections
    Connections {
        target: globalFavorites

        function onFavoritesChanged() {
            Plasmoid.configuration.favoriteApps = target.favorites;
        }
    }

    Connections {
        target: systemFavorites

        function onFavoritesChanged() {
            Plasmoid.configuration.favoriteSystemActions = target.favorites;
        }
    }

    Connections {
        target: Plasmoid.configuration

        function onFavoriteAppsChanged () {
            globalFavorites.favorites = Plasmoid.configuration.favoriteApps;
        }

        function onFavoriteSystemActionsChanged () {
            systemFavorites.favorites = Plasmoid.configuration.favoriteSystemActions;
        }

        function onHiddenApplicationsChanged() {
            rootModel.refresh();
        }
    }

    /*Connections {
        target: kicker

        function onExpandedChanged(expanded) {
            if (expanded) {
                windowSystem.monitorWindowVisibility(Plasmoid.fullRepresentationItem);
                justOpenedTimer.start();
            } else {
                kicker.reset();
            }
        }
    }*/

    // Models
    Kicker.RootModel {
        id: rootModel

        autoPopulate: false

        appNameFormat: 0
        flat: true
        sorted: true
        showSeparators: false
        appletInterface: kicker
        showAllApps: true
        showRecentApps: false
        showRecentDocs: false
        showPowerSession: false

        onShowRecentAppsChanged: {
            Plasmoid.configuration.showRecentApps = showRecentApps;
        }

        onShowRecentDocsChanged: {
            Plasmoid.configuration.showRecentDocs = showRecentDocs;
        }

        onRecentOrderingChanged: {
            Plasmoid.configuration.recentOrdering = recentOrdering;
        }

        Component.onCompleted: {
            favoritesModel.initForClient("org.kde.plasma.kicker.favorites.instance-" + Plasmoid.id)

            if (!Plasmoid.configuration.favoritesPortedToKAstats) {
                if (favoritesModel.count < 1) {
                    favoritesModel.portOldFavorites(Plasmoid.configuration.favoriteApps);
                }
                Plasmoid.configuration.favoritesPortedToKAstats = true;
            }
        }
    }

    Kicker.RunnerModel {
        id: runnerModel

        appletInterface: kicker

        favoritesModel: globalFavorites

        runners: {
            const results = ["krunner_services",
                             "krunner_systemsettings",
                             "krunner_sessions",
                             "krunner_powerdevil",
                             "calculator",
                             "unitconverter"];

            if (Plasmoid.configuration.useExtraRunners) {
                results.push(...Plasmoid.configuration.extraRunners);
            }

            return results;
        }
    }

    Kicker.DragHelper {
        id: dragHelper
        dragIconSize: Kirigami.Units.iconSizes.medium
    }

    Kicker.ProcessRunner {
        id: processRunner;
    }

    Kicker.WindowSystem {
        id: windowSystem
    }

    // Components
    Component {
        id: appLauncherRepresentationComponent
        AppLauncherRepresentation {}
    }

    KSvg.FrameSvgItem {
        id : highlightItemSvg

        visible: false

        imagePath: "widgets/viewitem"
        prefix: "hover"
    }

    KSvg.FrameSvgItem {
        id : panelSvg

        visible: false

        imagePath: "widgets/panel-background"
    }

    KSvg.FrameSvgItem {
        id : scrollbarSvg

        visible: false

        imagePath: "widgets/scrollbar"
    }

    KSvg.FrameSvgItem {
        id : backgroundSvg

        visible: false

        imagePath: "dialogs/background"
    }

    PlasmaComponents.Label {
        id: toolTipDelegate

        width: contentWidth
        height: undefined

        property Item toolTip

        text: toolTip ? toolTip.mainText : ""
        textFormat: Text.PlainText
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Edit Applications…")
            //icon.name: "kmenuedit"
            //icon.name: "kmenuedit-symbolic"
            icon.name: "story-editor"
            visible: Plasmoid.immutability !== PlasmaCore.Types.SystemImmutable
            onTriggered: processRunner.runMenuEditor()
        }
    ]

    /* Timer {
        id: justOpenedTimer

        repeat: false
        interval: 600
    } */

    Component.onCompleted: {
        if (Plasmoid.hasOwnProperty("activationTogglesExpanded")) {
            Plasmoid.activationTogglesExpanded = false
            //Plasmoid.activationTogglesExpanded = !kicker.isDash
        }

        windowSystem.focusIn.connect(enableHideOnWindowDeactivate);
        kicker.hideOnWindowDeactivate = true;

        rootModel.refreshed.connect(modelRefreshed);

        dragHelper.dropped.connect(resetDragSource);
    }
}
