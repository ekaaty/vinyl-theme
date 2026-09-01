/**
 * @file vinylstyle.h
 * @brief Main style class for the Vinyl theme.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#pragma once

#ifndef VINYLNXSTYLE_H
#define VINYLNXSTYLE_H

#include "breezestyle.h"
#include <functional>
#include <memory>

/**
 * @namespace Vinyl
 * @brief Namespace containing all Vinyl theme components.
 */
namespace Vinyl
{
    /**
     * @brief Forward declaration of the Helper class to improve compilation times.
     */
    class Helper;

    /**
     * @brief Main style class for the Vinyl theme, inheriting from Breeze::Style.
     * * This class manages the high-level drawing logic and fallbacks to the
     * Breeze base style when custom rendering is not defined.
     */
    class Style : public Breeze::Style
    {
        Q_OBJECT

    public:
        /**
         * @brief Default constructor.
         */
        Style();

        /**
         * @brief Virtual destructor.
         */
        virtual ~Style() = default;

        /** @name Reimplemented Drawing Methods */
        ///@{
        /**
         * @brief Draws standard control elements.
         * @param element The element to draw.
         * @param option Style options.
         * @param painter The painter object.
         * @param widget The widget being painted.
         */
        void drawControl(QStyle::ControlElement element, const QStyleOption* option,
                         QPainter* painter, const QWidget* widget) const override;

        /**
         * @brief Draws primitive elements (frames, buttons, etc.).
         * @param element The primitive element to draw.
         * @param option Style options.
         * @param painter The painter object.
         * @param widget The widget being painted.
         */
        void drawPrimitive(QStyle::PrimitiveElement element, const QStyleOption* option,
                           QPainter* painter, const QWidget* widget) const override;

        /**
         * @brief Draws complex controls (comboboxes, sliders, etc.).
         * @param element The complex control to draw.
         * @param option Style options.
         * @param painter The painter object.
         * @param widget The widget being painted.
         */
        void drawComplexControl(QStyle::ComplexControl element, const QStyleOptionComplex* option,
                                QPainter* painter, const QWidget* widget) const override;
        ///@}

    private:
        /** @brief Pointer to the helper class that handles specific widget rendering. */
        std::shared_ptr<Vinyl::Helper> _vinylHelper;

        /**
         * @brief Helper template to ensure the rendering helper is ready and to delegate the call.
         *
         * @tparam OptionType The type of the style option.
         * @tparam HelperFunc The helper function type.
         * * @param option Pointer to the style options.
         * @param painter The painter to use.
         * @param widget The target widget.
         * @param helperFunc The specific function to call in the helper.
         * @param args Extra arguments to helper function.
         * @return true if handled, false otherwise.
         */
        template <typename OptionType, typename HelperFunc, typename... Args>
        bool delegateToHelper(const OptionType* option, QPainter* painter,
                              const QWidget* widget, HelperFunc helperFunc, Args... args) const;

    };
}

#endif
