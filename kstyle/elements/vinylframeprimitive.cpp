/**
 * @file vinylframeprimitive.cpp
 * @brief Implementation of frame primitive rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylframeprimitive.h"
#include "../vinylhelper.h"
#include "vinylbreadcrumbs.h"

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

        // Delegate border rendering to the helper for consistency
        if (helper) {
            helper->drawBorderPrimitive(option, painter);
        }

        return true;
    }

    bool FramePrimitive::drawFrame(int element, const QStyleOption *option, QPainter *painter, const QWidget *widget, const Helper *helper)
    {
        Q_UNUSED(element);
        Q_UNUSED(widget);

        if (helper) {
            helper->drawBorderPrimitive(option, painter);
        }

        return true;
    }

} // namespace Vinyl
