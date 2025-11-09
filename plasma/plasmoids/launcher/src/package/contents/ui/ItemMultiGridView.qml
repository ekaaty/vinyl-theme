/*
    SPDX-FileCopyrightText: 2015 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2024-2025 Christian Tosta

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.private.kicker as Kicker

PlasmaComponents.ScrollView {
    id: itemMultiGrid

    width: parent.width

    implicitHeight: itemColumn.implicitHeight

    signal keyNavLeft(int subGridIndex)
    signal keyNavRight(int subGridIndex)
    signal keyNavUp()
    signal keyNavDown()

    property bool grabFocus: false
    property int cellSize
    property int iconSize
    property int numberCols

    property alias model: repeater.model
    property alias count: repeater.count
    property alias flickableItem: flickable

    function subGridAt(index) {
        return repeater.itemAt(index).itemGrid;
    }

    function tryActivate(row, col) { // FIXME TODO: Cleanup messy algo.
        if (flickable.contentY > 0) {
            row = 0;
        }

        var target = null;
        var rows = 0;

        for (var i = 0; i < repeater.count; i++) {
            var grid = subGridAt(i);

            if (rows <= row) {
                target = grid;
                rows += grid.lastRow() + 2; // Header counts as one.
            } else {
                break;
            }
        }

        if (target) {
            rows -= (target.lastRow() + 2);
            target.tryActivate(row - rows, col);
        }
    }

    onFocusChanged: {
        if (!focus) {
            for (var i = 0; i < repeater.count; i++) {
                subGridAt(i).focus = false;
            }
        }
    }

    Flickable {
        id: flickable

        flickableDirection: Flickable.VerticalFlick
        contentHeight: itemColumn.implicitHeight
        //focusPolicy: Qt.NoFocus

        Column {
            id: itemColumn

            width: itemMultiGrid.width - Kirigami.Units.gridUnit

            Repeater {
                id: repeater

                delegate: Item {
                    width: itemColumn.width
                    height: gridView.height + gridViewLabel.height + (Kirigami.Units.largeSpacing * 2)

                    property Item itemGrid: gridView
                    visible: gridView.count > 0

                    Kirigami.Heading {
                        id: gridViewLabel

                        anchors.top: parent.top

                        x: Kirigami.Units.smallSpacing
                        width: parent.width - x
                        height: dummyHeading.height

                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                        opacity: 1.0

                        color: Kirigami.Theme.textColor

                        level: 4

                        text: repeater.model.modelForRow(index).description
                        textFormat: Text.PlainText
                    }

                    MouseArea {
                        width: parent.width
                        height: parent.height
                        onClicked: root.toggle()
                    }

                    ItemGridView {
                        id: gridView

                        anchors {
                            top: gridViewLabel.bottom
                            topMargin: Kirigami.Units.largeSpacing
                        }

                        width: parent.width
                        height: Math.ceil(count / itemMultiGrid.numberCols) * itemMultiGrid.cellSize
                        spacing: itemMultiGrid.spacing
                        cellWidth: itemMultiGrid.cellSize
                        cellHeight: itemMultiGrid.cellSize
                        iconSize: itemMultiGrid.iconSize

                        verticalScrollBarPolicy: PlasmaComponents.ScrollBar.AlwaysOff

                        model: repeater.model.modelForRow(index)

                        onFocusChanged: {
                            if (focus) {
                                itemMultiGrid.focus = true;
                            }
                        }

                        onCountChanged: {
                            if (itemMultiGrid.grabFocus && index == 0 && count > 0) {
                                currentIndex = 0;
                                focus = true;
                            }
                        }

                        onCurrentItemChanged: {
                            if (!currentItem) {
                                return;
                            }

                            if (index == 0 && currentRow() === 0) {
                                flickable.contentY = 0;
                                return;
                            }

                            var y = currentItem.y;
                            y = contentItem.mapToItem(flickable.contentItem, 0, y).y;

                            if (y < flickable.contentY) {
                                flickable.contentY = y;
                            } else {
                                y += itemMultiGrid.cellSize;
                                y -= flickable.contentY;
                                y -= itemMultiGrid.height;

                                if (y > 0) {
                                    flickable.contentY += y;
                                }
                            }
                        }

                        onKeyNavLeft: {
                            itemMultiGrid.keyNavLeft(index);
                            currentIndex = -1
                        }

                        onKeyNavRight: {
                            itemMultiGrid.keyNavRight(index);
                            currentIndex = -1
                        }

                        onKeyNavUp: {
                            if (index > 0) {
                                var prevGrid = subGridAt(index - 1);
                                prevGrid.tryActivate(prevGrid.lastRow(), currentCol());
                            } else {
                                itemMultiGrid.keyNavUp();
                            }
                            currentIndex = -1
                        }

                        onKeyNavDown: {
                            if (index < repeater.count - 1) {
                                subGridAt(index + 1).tryActivate(0, currentCol());
                            } else {
                                itemMultiGrid.keyNavDown();
                            }
                            currentIndex = -1
                        }
                    }

                    // HACK: Steal wheel events from the nested grid view and forward them to
                    // the ScrollView's internal WheelArea.
                    Kicker.WheelInterceptor {
                        anchors.fill: gridView
                        z: 1

                        destination: findWheelArea(itemMultiGrid)
                    }
                }
            }
        }
    }
}
