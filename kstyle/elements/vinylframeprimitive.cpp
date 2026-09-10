/**
 * @file vinylframeprimitive.cpp
 * @brief Implementation of frame primitive rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylframeprimitive.h"
#include "../vinylhelper.h"
#include "vinyldolphinurlnavigator.h"

namespace Vinyl
{
    bool FramePrimitive::drawFrameLineEdit(int element, const QStyleOption* option, QPainter* painter,
                                           const QWidget* widget, const Helper* helper)
    {
        Q_UNUSED(element);

        // Delegate custom DolphinUrlNavigator handling if applicable
        if (DolphinUrlNavigator::draw(option, painter, widget)) {
            return true;
        }

        painter->save();
        painter->setRenderHint(QPainter::Antialiasing);

        // Delegate border rendering to the helper for consistency
        helper->drawBorderPrimitive(option, painter);

        painter->restore();
        return true;
    }

    /*
    void FramePrimitive::drawFrame(const QStyleOption* option, QPainter* painter, const QColor& borderColor)
    {
        const qreal radius = 4.0;
        const QRectF frameRect = QRectF(option->rect).adjusted(0.5, 0.5, -0.5, -0.5);

        painter->save();
        painter->setRenderHint(QPainter::Antialiasing);
        painter->setBrush(Qt::NoBrush);
        painter->setPen(QPen(borderColor, 1.0));
        painter->drawRoundedRect(frameRect, radius, radius);
        painter->restore();
    }
    */

} // namespace Vinyl
