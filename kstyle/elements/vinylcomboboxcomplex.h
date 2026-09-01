/**
 * @file vinylcomboboxcomplex.h
 * @brief Header for complex combobox rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLCOMBOBOXCOMPLEX_H
#define VINYLCOMBOBOXCOMPLEX_H

#include <QStyleOptionComplex>

namespace Vinyl
{
    class Helper;

    class ComboBoxComplex
    {
    public:
        /**
         * @brief Draws the complex ComboBox control, including panel, label, and arrow.
         * @param option Style options containing state and geometry.
         * @param painter The QPainter to use for drawing.
         * @param widget The widget being painted.
         * @param helper Pointer to the Vinyl style helper for shared primitives.
         * @return true if handled, false otherwise.
         */
        static bool drawComboBoxComplexControl(const QStyleOptionComplex* option, QPainter* painter,
                                               const QWidget* widget, const Helper* helper);
    };

} // namespace Vinyl

#endif // VINYLCOMBOBOXCOMPLEX_H
