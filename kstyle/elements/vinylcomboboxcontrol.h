/**
 * @file vinylcomboboxcontrol.h
 * @brief Header for control element rendering for ComboBox labels in the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLCOMBOBOXCONTROL_H
#define VINYLCOMBOBOXCONTROL_H

#include <QStyleOption>

namespace Vinyl {

    class Helper;

    class ComboBoxControl {
    public:
        /**
         * @brief Draws the label (text and icon) for a ComboBox.
         * @param option Style options containing state, text, and icon.
         * @param painter The QPainter to use for drawing.
         * @param widget The widget being painted.
         * @param helper Pointer to the Vinyl style helper for shared utilities.
         * @return true if handled, false otherwise.
         */
        static bool drawComboBoxLabel(const QStyleOption *option, QPainter *painter,
                                    const QWidget *widget, const Helper *helper);
    };

} // namespace Vinyl

#endif // VINYLCOMBOBOXCONTROL_H
