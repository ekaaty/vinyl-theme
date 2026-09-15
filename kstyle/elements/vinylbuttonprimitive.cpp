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
#include <QMetaObject>

namespace Vinyl {

bool ButtonPrimitive::isStatusBar(const QWidget *widget)
{
    if (!widget) {
        return false;
    }

    const QWidget *parent = widget;
    while (parent) {
        const QMetaObject *meta = parent->metaObject();
        if (meta) {
            const QByteArray className = meta->className();
            if (className == QByteArray("KateStatusBar") || className == QByteArray("QStatusBar") || className == QByteArray("KStatusBar")) {
                return true;
            }
        }
        parent = parent->parentWidget();
    }

    return false;
}

    bool ButtonPrimitive::drawPanelButtonCommand(const QStyleOption *option, QPainter *painter,
                                                 const QWidget *widget, const Helper *helper)
    {
        const QStyle::State &state = option->state;
        const bool inStatus = isStatusBar(widget);

        if (inStatus) {
            if (!(state & (QStyle::State_MouseOver | QStyle::State_Sunken | QStyle::State_On))) {
                return true;
            }

            QColor fill = option->palette.color(QPalette::ButtonText);
            fill.setAlphaF(state & QStyle::State_Sunken ? 0.20 : 0.08);

            const qreal margin = 1.0;
            const QRectF rect = QRectF(option->rect).adjusted(margin, margin, -margin, -margin);

            painter->save();
            painter->setRenderHint(QPainter::Antialiasing);
            painter->setPen(Qt::NoPen);
            painter->setBrush(fill);
            painter->drawRoundedRect(rect, 4.0, 4.0);
            painter->restore();

            return true;
        }

        const auto buttonOption = qstyleoption_cast<const QStyleOptionButton*>(option);
        const bool flat = buttonOption && (buttonOption->features & QStyleOptionButton::Flat);
        const bool toggle = (widget && widget->inherits("QAbstractButton") && static_cast<const QAbstractButton *>(widget)->isCheckable());

        if ((flat || toggle) && !(state & (QStyle::State_MouseOver | QStyle::State_HasFocus | QStyle::State_Sunken | QStyle::State_On))) {
            return true;
        }

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
        Q_UNUSED(helper);

        const QStyle::State &state = option->state;

        if (!(state & (QStyle::State_MouseOver | QStyle::State_Sunken | QStyle::State_On))) {
            return true;
        }

        QStyleOptionToolButton copy;
        if (const auto v = qstyleoption_cast<const QStyleOptionToolButton*>(option)) {
            copy = *v;
        } else {
            copy.QStyleOption::operator=(*option);
        }

        copy.features &= ~QStyleOptionToolButton::HasMenu;

        const qreal margin = 2.0;
        copy.rect = option->rect.adjusted(margin, margin, -margin, -margin);

        QColor highlight = isStatusBar(widget) ? option->palette.color(QPalette::ButtonText) : option->palette.color(QPalette::Highlight);

        highlight.setAlphaF(state & QStyle::State_Sunken ? 0.9 : 0.6);

        const qreal radius = 4.0;

        painter->save();
        painter->setRenderHint(QPainter::Antialiasing);
        painter->setPen(Qt::NoPen);
        painter->setBrush(highlight);
        painter->drawRoundedRect(copy.rect, radius, radius);
        painter->restore();

        return true;
    }

    bool ButtonPrimitive::drawIndicatorButtonDropDown(const QStyleOption *option, QPainter *painter,
                                                      const QWidget *widget, const Helper *helper)
    {
        Q_UNUSED(widget);

        if (option->rect.isEmpty()) return false;

        const QRectF arrowRect = option->rect;
        const QPalette::ColorRole role = (option->state & (QStyle::State_Sunken | QStyle::State_On)) ? QPalette::HighlightedText : QPalette::ButtonText;

        const QColor arrowColor = option->palette.color(role);
        helper->renderArrow(painter, arrowRect, arrowColor, Breeze::ArrowDown);

        return true;
    }

} // namespace Vinyl
