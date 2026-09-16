/**
 * @file vinylbreadcrumbs.cpp
 * @brief Implementation of Breadcrumbs rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylbreadcrumbs.h"
#include "vinylmetrics.h"

#include <QComboBox>
#include <QLineEdit>

namespace Vinyl
{
bool DolphinUrlNavigator::draw(const QStyleOption *option, QPainter *painter, const QWidget *widget)
{
    if (!widget || !widget->inherits("DolphinUrlNavigator")) {
        return false;
    }

    const auto comboBox = widget->findChild<QComboBox *>();
    if (!comboBox || comboBox->isVisible()) {
        return false;
    }

    // Breadcrumbs view (non-editable mode)
    const QPalette &palette = option->palette;
    const bool hasFocus = option->state.testFlag(QStyle::State_HasFocus);
    const bool hasHover = option->state.testFlag(QStyle::State_MouseOver);

    // Neutral border logic: Highlight only when focused or hovered
    QColor outlineColor = palette.color(QPalette::Highlight);
    if (!hasFocus) {
        if (hasHover) {
            outlineColor.setAlpha(100);
        } else {
            outlineColor.setAlpha(0);
        }
    }

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    // Fine-tuned rectangle to align height perfectly with standard dialogs
    const QRectF rect = QRectF(option->rect).adjusted(1.0, 3.0, -2.0, -2.0);

    painter->setPen(QPen(outlineColor, Metrics::BorderWidth));
    painter->setBrush(Qt::NoBrush);
    painter->drawRoundedRect(rect, Metrics::CornerRadius, Metrics::CornerRadius);
    painter->restore();

    // Ensure internal line edit shares window color without redundant updates
    if (auto dolphinLineEdit = widget->findChild<QLineEdit *>()) {
        const QColor windowColor = palette.color(QPalette::Window);
        if (dolphinLineEdit->palette().color(QPalette::Window) != windowColor) {
            QPalette pal = dolphinLineEdit->palette();
            pal.setColor(QPalette::Window, windowColor);
            dolphinLineEdit->setPalette(pal);
        }
    }

    return true;
}

} // namespace Vinyl
