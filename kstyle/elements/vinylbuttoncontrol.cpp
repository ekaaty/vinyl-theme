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

namespace Vinyl {

    bool ButtonControl::drawPushButtonLabel(const QStyleOption *option, QPainter *painter,
                                            const QWidget *widget, const Helper *helper)
    {
        Q_UNUSED(widget);
        Q_UNUSED(helper);

        // 1. Cast and Validation
        const auto buttonOption = qstyleoption_cast<const QStyleOptionButton*>(option);
        if (!buttonOption) return false;

        const QRect &rect = buttonOption->rect;
        const bool enabled = buttonOption->state & QStyle::State_Enabled;
        const bool hasText = !buttonOption->text.isEmpty();
        const bool hasIcon = !buttonOption->icon.isNull();

        painter->save();

        // 2. Define Text Color (Adaptive Palette)
        QColor textColor = enabled
            ? buttonOption->palette.color(QPalette::ButtonText)
            : buttonOption->palette.color(QPalette::Disabled, QPalette::ButtonText);

        painter->setOpacity(enabled ? 1.0 : 0.15);

        // 3. Geometry and Metrics Calculation
        // Spacing between icon and text only if both are present
        const int spacing = (hasIcon && hasText) ? 4 : 0;
        const QSize iconSize = buttonOption->iconSize;
        
        // Calculate precise text width including mnemonic (&) character handling
        const int textFlags = Qt::TextShowMnemonic | Qt::AlignLeft | Qt::AlignVCenter;
        const int textWidth = hasText ? option->fontMetrics.boundingRect(rect, textFlags, buttonOption->text).width() : 0;
        
        // Total width of the combined block (Icon + Spacing + Text)
        const int contentWidth = (hasIcon ? iconSize.width() : 0) + spacing + textWidth;

        // Calculate the horizontal start point (X) to absolutely center the entire content block
        int xOffset = rect.left() + (rect.width() - contentWidth) / 2;

        // 4. Icon Rendering
        if (hasIcon) {
            QRect iconRect(xOffset, rect.top() + (rect.height() - iconSize.height()) / 2,
                        iconSize.width(), iconSize.height());

            // Handle Layout Direction (LTR/RTL) using the QStyle static method
            iconRect = QStyle::visualRect(option->direction, rect, iconRect);

            // Determine icon mode based on interaction state
            QIcon::Mode mode = enabled ? QIcon::Normal : QIcon::Disabled;
            if (enabled && (buttonOption->state & QStyle::State_MouseOver)) {
                mode = QIcon::Active;
            }

            buttonOption->icon.paint(painter, iconRect, Qt::AlignCenter, mode);
            
            // Move the xOffset forward to position the text after the icon
            xOffset += iconSize.width() + spacing;
        }

        // 5. Text Rendering
        if (hasText) {
            painter->setPen(textColor);

            // Define text rectangle based on the calculated offset
            QRect textRect(xOffset, rect.top(), textWidth + 2, rect.height());
            
            // Handle Layout Direction (LTR/RTL) for text positioning
            textRect = QStyle::visualRect(option->direction, rect, textRect);

            // Special Rendering for CommandLinkButton features (usually left-aligned with margin)
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
