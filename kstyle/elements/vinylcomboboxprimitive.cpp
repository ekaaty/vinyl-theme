/**
 * @file vinylcomboboxprimitive.cpp
 * @brief Implementation of primitive combobox rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylcomboboxprimitive.h"
#include "../vinylhelper.h"

#include <QStyleOptionComboBox>

namespace Vinyl {

    bool ComboBoxPrimitive::drawPanelComboBox(const QStyleOption *option, QPainter *painter,
                                              const QWidget *widget, const Helper *helper)
    {
        Q_UNUSED(widget);
        const auto cb = qstyleoption_cast<const QStyleOptionComboBox*>(option);

        const bool mouseOver = option->state & QStyle::State_MouseOver;
        const bool hasFocus = option->state & QStyle::State_HasFocus;
        const bool sunken = option->state & QStyle::State_Sunken;

        const qreal margin = 1.0;

        if (cb && !cb->frame && !(mouseOver | hasFocus | sunken)) {
            return true;
        }

        QStyleOption copy = *option;
        copy.rect = option->rect.adjusted(margin, margin, -margin, -margin);

        helper->drawBorderPrimitive(&copy, painter);
        if (cb && !cb->editable) {
            helper->drawBackgroundPrimitive(&copy, painter);
        }

        return true;
    }

}
