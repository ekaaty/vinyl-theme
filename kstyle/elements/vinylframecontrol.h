/**
 * @file vinylframecontrol.h
 * @brief Header for frame control rendering in the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLFRAMECONTROL_H
#define VINYLFRAMECONTROL_H

#include <QPainter>
#include <QStyle>
#include <QStyleOption>
#include <QWidget>

namespace Vinyl
{
class Helper;

/**
 * @brief The FrameControl class handles the drawing of frame-related controls.
 */
class FrameControl
{
public:
    /**
     * @brief Draws a shaped frame control using the style helper.
     */
    static bool drawShapedFrame(int element, const QStyleOption *option, QPainter *painter, const QWidget *widget, const Helper *helper);
};

} // namespace Vinyl

#endif // VINYLFRAMECONTROL_H
