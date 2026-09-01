/**
 * @file vinylbuttoncontrol.h
 * @brief Handles rendering of button-related control elements (labels, icons).
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLBUTTONCONTROL_H
#define VINYLBUTTONCONTROL_H

#include <QStyleOption>
#include <QPainter>
#include <QWidget>

namespace Vinyl {

class Helper;

/**
 * @class ButtonControl
 * @brief Static providers for rendering push button contents.
 */
class ButtonControl {
public:
    /**
     * @brief Renders the label (text and icon) of a push button.
     * @param option Style options.
     * @param painter Target painter.
     * @param widget Source widget.
     * @param helper Pointer to the Helper for shared resources.
     * @return true if rendered.
     */
    static bool drawPushButtonLabel(const QStyleOption *option, QPainter *painter,
                                   const QWidget *widget, const Helper *helper);
};

} // namespace Vinyl

#endif // VINYLBUTTONCONTROL_H
