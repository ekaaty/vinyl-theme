/**
 * @file vinylcomboboxcontrol.cpp
 * @brief Implementation of control element rendering for ComboBox labels in the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylcomboboxcontrol.h"
#include "../vinylhelper.h"

#include <QStyleOptionComboBox>
#include <QPainter>


namespace Vinyl {

    bool ComboBoxControl::drawComboBoxLabel(const QStyleOption *option, QPainter *painter,
                                            const QWidget *widget, const Helper *helper)
    {
        Q_UNUSED(widget);

        const auto cb = qstyleoption_cast<const QStyleOptionComboBox*>(option);
        if (!cb) return false;
        if (cb->editable) return true;

        // Base Geometry (Vinyl: 6px left padding, ~22px reserved for arrow)
        QRect logicalRect = cb->rect;
        logicalRect.adjust(6, 0, -22, 0);
        QRect contentRect = QStyle::visualRect(option->direction, cb->rect, logicalRect);

        // draw icon
        if (!cb->currentIcon.isNull()) {
            helper->drawIconPrimitive(painter, contentRect, option, cb->currentIcon, cb->iconSize);

            // Logical adjust: move text into the widget
            if (option->direction == Qt::RightToLeft)
                contentRect.setRight(contentRect.right() - cb->iconSize.width() - 4);
            else
                contentRect.setLeft(contentRect.left() + cb->iconSize.width() + 4);
        }

        // draw label text
        helper->drawTextPrimitive(painter, contentRect, option, cb->currentText,
                                  cb->textAlignment ? cb->textAlignment : (Qt::AlignLeft | Qt::AlignVCenter));

        return true;
    }

}
