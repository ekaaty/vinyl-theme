/**
 * @file vinylcomboboxprimitive.h
 * @brief Header for primitive combobox rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLCOMBOBOXPRIMITIVE_H
#define VINYLCOMBOBOXPRIMITIVE_H

#include <QStyleOption>

namespace Vinyl {

    class Helper;

    class ComboBoxPrimitive {
    public:
        /**
         * @brief Draws the background and border panel for a ComboBox.
         * @param option Style options containing state and geometry.
         * @param painter The QPainter to use for drawing.
         * @param widget The widget being painted.
         * @param helper Pointer to the Vinyl style helper for shared primitives.
         * @return true if handled, false otherwise.
         */
        static bool drawPanelComboBox(const QStyleOption *option, QPainter *painter,
                                    const QWidget *widget, const Helper *helper);
    };

} // namespace Vinyl

#endif // VINYLCOMBOBOXPRIMITIVE_H
