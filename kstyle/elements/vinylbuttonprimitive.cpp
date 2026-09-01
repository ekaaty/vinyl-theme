/**
 * @file vinylbuttonprimitive.cpp
 * @brief Implementation of primitive button rendering for the Vinyl style.
 *
 * This file handles the low-level painting of button panels (Command and Tool).
 * It uses the data from QStyleOption to determine states like MouseOver,
 * Sunken (pressed), and On (checked).
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylbuttonprimitive.h"
#include "../vinylhelper.h"

#include <QAbstractButton>

namespace Vinyl {

    bool ButtonPrimitive::drawPanelButtonCommand(const QStyleOption *option, QPainter *painter,
                                                 const QWidget *widget, const Helper *helper)
    {
        const auto buttonOption = qstyleoption_cast<const QStyleOptionButton*>(option);
        const bool flat = buttonOption && (buttonOption->features & QStyleOptionButton::Flat);
        const bool toggle = (widget && widget->inherits("QAbstractButton") &&
                             static_cast<const QAbstractButton*>(widget)->isCheckable());

        const QStyle::State &state = option->state;

        if ((flat || toggle) &&
            !(state & QStyle::State_MouseOver) &&
            !(state & QStyle::State_HasFocus) &&
            !(state & QStyle::State_Sunken) &&
            !(state & QStyle::State_On)) {
            return true;
        }

        // Set padding
        const qreal margin = 2.0; 
        QStyleOption copy = *option;
        copy.rect = option->rect.adjusted(margin, margin, -margin, -margin);
        
        helper->drawBackgroundPrimitive(&copy, painter);
        helper->drawBorderPrimitive(&copy, painter);

        return true;
    }

    bool ButtonPrimitive::drawPanelButtonTool(const QStyleOption *option, QPainter *painter,
                                              const QWidget *widget, const Helper *helper)
    {
        Q_UNUSED(widget);
        Q_UNUSED(helper);

        const QStyle::State &state = option->state;

        // Tool buttons usually stay flat until interacted with
        if (!(state & QStyle::State_MouseOver) &&
            !(state & QStyle::State_Sunken) &&
            !(state & QStyle::State_On))
        {
            return true;
        }

        QStyleOptionToolButton copy;
        if (const auto v = qstyleoption_cast<const QStyleOptionToolButton*>(option)) {
            copy = *v;
        } else {
            // Fallback for non-toolbutton calls
            copy.QStyleOption::operator=(*option);
        }

        // We clear the 'HasMenu' feature in our copy so that any internal 
        // calculation (like Breeze's) doesn't try to split the button in two.
        copy.features &= ~QStyleOptionToolButton::HasMenu;

        // TODO: Simplify this to use helper->DrawBackgroundPrimitive

        // Set padding
        const qreal margin = 2.0;
        copy.rect = option->rect.adjusted(margin, margin, -margin, -margin);

        QColor highlight = option->palette.highlight().color();

        // Adjust opacity based on interaction depth
        highlight.setAlphaF(state & QStyle::State_Sunken ? 0.9 : 0.6);

        const qreal radius = 4.0;
        
        painter->save();
        painter->setRenderHint(QPainter::Antialiasing);
        painter->setPen(Qt::NoPen);
        painter->setBrush(highlight);
        painter->drawRoundedRect(copy.rect, radius, radius);
        painter->restore();

        //helper->drawBorderPrimitive(&copy, painter);

        return true;
    }

    bool ButtonPrimitive::drawIndicatorButtonDropDown(const QStyleOption *option, QPainter *painter,
                                                      const QWidget *widget, const Helper *helper)
    {
        Q_UNUSED(widget);

        // Validation: Ensure we are dealing with a non-empty area
        if (option->rect.isEmpty()) return false;

        // Geometry: Define the arrow area
        // We use the sub-rect provided by the style (option->rect)
        // No extra borders or backgrounds are drawn here to keep the panel unified
        QRectF arrowRect = option->rect;

        // Color: Define the arrow color based on the current state
        // Typically we use the ButtonText color for consistency
        QPalette::ColorRole role = (option->state & (QStyle::State_Sunken | QStyle::State_On)) 
                                   ? QPalette::HighlightedText 
                                   : QPalette::ButtonText;

        const QColor arrowColor = option->palette.color(role);

        // Rendering: Draw only the arrow glyph
        // We use ArrowDown for the drop-down indicator
        // This avoids drawing any separator lines or internal boxes
        helper->renderArrow(painter, arrowRect, arrowColor, Breeze::ArrowDown);

        return true;
    }

} // namespace Vinyl
