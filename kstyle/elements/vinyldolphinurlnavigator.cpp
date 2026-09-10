/**
 * @file vinyldolphinurlnavigator.cpp
 * @brief Implementation of DolphinUrlNavigator custom rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinyldolphinurlnavigator.h"

#include <QComboBox>
#include <QLineEdit>

namespace Vinyl
{
bool DolphinUrlNavigator::draw(const QStyleOption *option, QPainter *painter, const QWidget *widget)
{
    if (!widget || !widget->inherits("DolphinUrlNavigator")) {
        return false;
    }

    if (auto comboBox = widget->findChild<QComboBox *>()) {
        const bool isVisible = comboBox->isVisible();

        // Breadcrumbs view (non-editable mode)
        if (!isVisible) {
            painter->save();
            // Fill with window background color to seamlessly blend with the toolbar
            painter->fillRect(option->rect, option->palette.color(QPalette::Window));

            if (QLineEdit *dolphinLineEdit = widget->findChild<QLineEdit *>()) {
                QPalette pal(dolphinLineEdit->palette());
                pal.setColor(QPalette::Window, option->palette.color(QPalette::Window));
                dolphinLineEdit->setPalette(pal);
            }
            painter->restore();
            return true;
        }
    }

    return false;
}

} // namespace Vinyl
