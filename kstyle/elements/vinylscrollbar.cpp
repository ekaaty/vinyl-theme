/**
 * @file vinylscrollbar.cpp
 * @brief ScrollBar element rendering implementation.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylscrollbar.h"
#include "../vinylhelper.h"
#include "../vinylmetrics.h"
#include <QStyleOptionSlider>

namespace Vinyl
{

QRect ScrollBarElement::subControlRect(const QStyleOptionComplex *option, QStyle::SubControl subControl, const QWidget *widget)
{
    const auto *scrollBarOpt = qstyleoption_cast<const QStyleOptionSlider *>(option);
    if (!scrollBarOpt) {
        return QRect();
    }

    const int margin = Metrics::ScrollBarMargin;
    QRect rect = option->rect;

    // Detect KTextEditor Minimap scrollbar via widget property or geometry width
    const bool isMinimap = (scrollBarOpt->orientation == Qt::Vertical)
        && ((widget && widget->property("minimap").toBool()) || (option->rect.width() > (Metrics::TrackThickness * 2)));

    switch (subControl) {
    case QStyle::SC_ScrollBarGroove: {
        if (isMinimap) {
            return option->rect;
        }

        if (scrollBarOpt->orientation == Qt::Vertical) {
            rect.adjust(0, margin, 0, -margin);
            rect.setWidth(Metrics::TrackThickness);
            rect.moveCenter(QPoint(option->rect.center().x(), rect.center().y()));
        } else {
            rect.adjust(margin, 0, -margin, 0);
            rect.setHeight(Metrics::TrackThickness);
            rect.moveCenter(QPoint(rect.center().x(), option->rect.center().y()));
        }
        return rect;
    }
    case QStyle::SC_ScrollBarSlider: {
        const int usableLen = ((scrollBarOpt->orientation == Qt::Vertical) ? option->rect.height() : option->rect.width()) - (2 * margin);
        const int maxRange = std::max(1, scrollBarOpt->maximum - scrollBarOpt->minimum + scrollBarOpt->pageStep);
        int sliderLen = std::max(Metrics::ScrollBarMinSpace, (scrollBarOpt->pageStep * usableLen) / maxRange);

        int sliderPos = 0;
        if (scrollBarOpt->maximum > scrollBarOpt->minimum) {
            sliderPos = ((scrollBarOpt->sliderPosition - scrollBarOpt->minimum) * (usableLen - sliderLen)) / (scrollBarOpt->maximum - scrollBarOpt->minimum);
        }

        if (scrollBarOpt->orientation == Qt::Vertical) {
            const int width = isMinimap ? option->rect.width() : Metrics::TrackThickness;
            rect.setRect(option->rect.left(), option->rect.top() + margin + sliderPos, width, sliderLen);
            if (!isMinimap) {
                rect.moveCenter(QPoint(option->rect.center().x(), rect.center().y()));
            }
        } else {
            rect.setRect(option->rect.left() + margin + sliderPos, option->rect.top(), sliderLen, Metrics::TrackThickness);
            rect.moveCenter(QPoint(rect.center().x(), option->rect.center().y()));
        }
        return rect;
    }
    default:
        break;
    }
    return QRect();
}

bool ScrollBarElement::drawComplexControl(const QStyleOptionComplex *option, QPainter *painter, const QWidget *widget, const Helper *helper)
{
    Q_UNUSED(helper);
    const auto *scrollBarOpt = qstyleoption_cast<const QStyleOptionSlider *>(option);
    if (!scrollBarOpt) {
        return false;
    }

    // Identify if the scrollbar belongs to KTextEditor minimap
    const bool isMinimap = (scrollBarOpt->orientation == Qt::Vertical)
        && ((widget && widget->property("minimap").toBool()) || (option->rect.width() > (Metrics::TrackThickness * 2)));

    const bool isHover = option->state & QStyle::State_MouseOver;

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    // Suppress track groove background when rendering inside the minimap area
    if (!isMinimap && (scrollBarOpt->subControls & QStyle::SC_ScrollBarGroove) && isHover) {
        QRect grooveRect = subControlRect(option, QStyle::SC_ScrollBarGroove, widget);
        QColor grooveColor = option->palette.color(QPalette::WindowText);
        grooveColor.setAlphaF(0.15);

        painter->setPen(Qt::NoPen);
        painter->setBrush(grooveColor);
        painter->drawRoundedRect(grooveRect, Metrics::TrackRadius, Metrics::TrackRadius);
    }

    // Render the slider handle
    if (scrollBarOpt->subControls & QStyle::SC_ScrollBarSlider) {
        QRect handleRect = subControlRect(option, QStyle::SC_ScrollBarSlider, widget);

        QColor handleColor = isHover ? option->palette.color(QPalette::Highlight) : option->palette.color(QPalette::ButtonText);

        if (!isHover) {
            handleColor.setAlphaF(isMinimap ? 0.20 : 0.35);
        }

        painter->setPen(Qt::NoPen);
        painter->setBrush(handleColor);

        if (isMinimap) {
            // Draw simple flat overlay for minimap slider selection area
            painter->drawRect(handleRect);
        } else {
            painter->drawRoundedRect(handleRect, Metrics::TrackRadius, Metrics::TrackRadius);
        }
    }

    painter->restore();
    return true;
}

} // namespace Vinyl
