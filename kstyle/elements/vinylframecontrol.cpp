/**
 * @file vinylframecontrol.cpp
 * @brief Implementation of frame control rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylframecontrol.h"
#include "../vinylhelper.h"

namespace Vinyl
{
bool FrameControl::drawShapedFrame(int element, const QStyleOption *option, QPainter *painter, const QWidget *widget, const Helper *helper)
{
    Q_UNUSED(element);
    Q_UNUSED(painter);
    Q_UNUSED(helper);

    const auto frameOpt = qstyleoption_cast<const QStyleOptionFrame *>(option);
    if (!frameOpt) {
        return false;
    }

    switch (frameOpt->frameShape) {
    case QFrame::StyledPanel: {
        if (widget && widget->inherits("DolphinUrlNavigator")) {
            return true;
        }
        break;
    }

    default:
        break;
    }

    return false;
}
} // namespace Vinyl
