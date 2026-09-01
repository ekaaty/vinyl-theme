/**
 * @file vinylbuttonprimitive.h
 * @brief Handles the rendering of primitive button elements.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLBUTTONPRIMITIVE_H
#define VINYLBUTTONPRIMITIVE_H

#include <QStyleOption>
#include <QPainter>
#include <QWidget>

namespace Vinyl {

    class Helper; // Forward declaration

    /**
     * @class ButtonPrimitive
     * @brief Static provider for PushButton and ToolButton backgrounds.
     * * This class implements the low-level visual appearance (panels) of
     * button-like elements according to the Vinyl "stable" specifications.
     */
    class ButtonPrimitive {
    public:
        /**
         * @brief Renders the standard PushButton command panel.
         * @param option Style options.
         * @param painter Target painter.
         * @param widget Source widget.
         * @param helper Pointer to the Helper for shared resources.
         * @return true if rendered.
         */
        static bool drawPanelButtonCommand(const QStyleOption *option, QPainter *painter,
                                           const QWidget *widget, const Helper *helper);

        /**
         * @brief Renders the ToolButton (toolbar/flat) panel.
         * @param option Style options.
         * @param painter Target painter.
         * @param widget Source widget.
         * @param helper Pointer to the Helper for shared resources.
         * @return true if rendered.
         */
        static bool drawPanelButtonTool(const QStyleOption *option, QPainter *painter,
                                        const QWidget *widget, const Helper *helper);

        /**
         * @brief Renders the drop-down indicator for buttons with menus.
         * @param option Style options.
         * @param painter Target painter.
         * @param widget Source widget.
         * @param helper Pointer to the Helper for shared resources.
         * @return true if rendered.
         */
        static bool drawIndicatorButtonDropDown(const QStyleOption *option, QPainter *painter,
                                                const QWidget *widget, const Helper *helper);

    };

} // namespace Vinyl

#endif // VINYLBUTTONPRIMITIVE_H
