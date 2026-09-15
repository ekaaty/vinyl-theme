/**
 * @file vinylbuttoncontrol.cpp
 * @brief Handles rendering of button-related control elements (labels, icons).
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylbuttoncontrol.h"
#include "../vinylhelper.h"

#include <QStyle>
#include <QStyleOptionButton>

namespace Vinyl {

    bool ButtonControl::drawPushButtonLabel(const QStyleOption *option, QPainter *painter,
                                            const QWidget *widget, const Helper *helper)
    {
        Q_UNUSED(widget);
        Q_UNUSED(helper);

        // Cast and validation
        const auto buttonOption = qstyleoption_cast<const QStyleOptionButton*>(option);
        if (!buttonOption) {
            return false;
        }

        const QRect &rect = buttonOption->rect;
        const bool enabled = buttonOption->state & QStyle::State_Enabled;
        const bool hasText = !buttonOption->text.isEmpty();
        const bool hasIcon = !buttonOption->icon.isNull();

        painter->save();

        // Text color configuration
        QColor textColor = enabled ? buttonOption->palette.color(QPalette::ButtonText) : buttonOption->palette.color(QPalette::Disabled, QPalette::ButtonText);

        painter->setOpacity(enabled ? 1.0 : 0.15);

        // Geometry and metrics calculation
        const int spacing = (hasIcon && hasText) ? 4 : 0;
        const QSize iconSize = buttonOption->iconSize;

        const int textFlags = Qt::TextShowMnemonic | Qt::AlignLeft | Qt::AlignVCenter;
        const int textWidth = hasText ? option->fontMetrics.boundingRect(rect, textFlags, buttonOption->text).width() : 0;

        const int contentWidth = (hasIcon ? iconSize.width() : 0) + spacing + textWidth;

        int xOffset = rect.left() + (rect.width() - contentWidth) / 2;

        // Icon rendering
        if (hasIcon) {
            QRect iconRect(xOffset, rect.top() + (rect.height() - iconSize.height()) / 2, iconSize.width(), iconSize.height());

            iconRect = QStyle::visualRect(option->direction, rect, iconRect);

            QIcon::Mode mode = enabled ? QIcon::Normal : QIcon::Disabled;
            if (enabled && (buttonOption->state & QStyle::State_MouseOver)) {
                mode = QIcon::Active;
            }

            buttonOption->icon.paint(painter, iconRect, Qt::AlignCenter, mode);

            xOffset += iconSize.width() + spacing;
        }

        // Text rendering
        if (hasText) {
            painter->setPen(textColor);

            QRect textRect(xOffset, rect.top(), textWidth + 2, rect.height());
            textRect = QStyle::visualRect(option->direction, rect, textRect);

            if (buttonOption->features & QStyleOptionButton::CommandLinkButton) {
                QRect commandRect = rect.adjusted(hasIcon ? iconSize.width() + 8 : 4, 0, 0, 0);
                painter->drawText(commandRect, textFlags, buttonOption->text);
            } else {
                painter->drawText(textRect, textFlags, buttonOption->text);
            }
        }

        painter->restore();
        return true;
    }

} // namespace Vinyl
