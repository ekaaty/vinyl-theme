/**
 * @file vinylstyle.cpp
 * @brief Implementation of the Vinyl theme style engine.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylstyle.h"
#include "vinylhelper.h"

#include <KSharedConfig>
#include <QLoggingCategory>

Q_LOGGING_CATEGORY(VINYLNX, "vinylnx")

namespace Vinyl
{
    // =================================================================
    // CONSTRUCTOR
    // =================================================================

    Style::Style() : Breeze::Style()
    {
        auto config = KSharedConfig::openConfig();
        _vinylHelper = std::make_shared<Vinyl::Helper>(config);
    }

    // =================================================================
    // TEMPLATES FOR DISPATCHING & DELEGATION
    // =================================================================

    template <typename OptionType, typename HelperFunc, typename... Args>
    bool Style::delegateToHelper(const OptionType* option, QPainter* painter,
                                 const QWidget* widget,HelperFunc helperFunc, Args... args) const
    {
        if (!_vinylHelper) {
            // const_cast is necessary because draw is const, but member initiation is not
            const_cast<Style*>(this)->_vinylHelper = std::make_shared<Vinyl::Helper>(KSharedConfig::openConfig());
        }

        return (_vinylHelper.get()->*helperFunc)(option, painter, widget, args...);
    }

    // =================================================================
    // REIMPLEMENTED DRAWING METHODS (OVERRIDES)
    // =================================================================

    void Style::drawComplexControl(QStyle::ComplexControl element, const QStyleOptionComplex* option,
                                   QPainter* painter, const QWidget* widget) const
    {
        painter->save();
        bool handled = delegateToHelper(option, painter, widget,
                                        &Vinyl::Helper::vinylDrawComplexControl,
                                        static_cast<int>(element));
        painter->restore();

        if (handled) return;

        this->Breeze::Style::drawComplexControl(element, option, painter, widget);
    }

    void Style::drawControl(QStyle::ControlElement element, const QStyleOption* option,
                            QPainter* painter, const QWidget* widget) const
    {
        painter->save();
        bool handled = delegateToHelper(option, painter, widget,
                                        &Vinyl::Helper::vinylDrawControl,
                                        static_cast<int>(element));
        painter->restore();

        if (handled) return;

        this->Breeze::Style::drawControl(element, option, painter, widget);
    }

    void Style::drawPrimitive(QStyle::PrimitiveElement element, const QStyleOption* option,
                              QPainter* painter, const QWidget* widget) const
    {
        painter->save();
        bool handled = delegateToHelper(option, painter, widget,
                                        &Vinyl::Helper::vinylDrawPrimitive,
                                        static_cast<int>(element));
        painter->restore();

        if (handled) return;

        this->Breeze::Style::drawPrimitive(element, option, painter, widget);    
    }

    // =================================================================
    // HELPER CALL FUNCTIONS (TO BE DEFINED)
    // =================================================================

}
