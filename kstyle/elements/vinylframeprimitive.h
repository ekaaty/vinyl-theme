/**
 * @file vinylframeprimitive.h
 * @brief Header for frame primitive rendering in the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLFRAMEPRIMITIVE_H
#define VINYLFRAMEPRIMITIVE_H

#include <QStyle>
#include <QStyleOption>
#include <QPainter>
#include <QWidget>

namespace Vinyl
{
    class Helper;

    /**
     * @brief The FramePrimitive class handles the drawing of frame-related primitives.
     * This includes LineEdits, GroupBoxes, and general frames.
     */
    class FramePrimitive
    {
    public:
        /**
         * @brief Draws the frame for a QLineEdit.
         */
        static bool drawFrameLineEdit(int element, const QStyleOption* option, QPainter* painter,
                                      const QWidget* widget, const Helper* helper);

    private:
        /**
         * @brief Draws a generic frame primitive using the style helper.
         */
        static bool drawFrame(int element, const QStyleOption *option, QPainter *painter, const QWidget *widget, const Helper *helper);
    };

} // namespace Vinyl

#endif // VINYLFRAMEPRIMITIVE_H
