/**
 * @file vinylslider.cpp
 * @brief Slider element rendering implementation.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "vinylslider.h"
#include "../vinylhelper.h"
#include "../vinylmetrics.h"
#include <QStyleOptionSlider>

namespace Vinyl
{

QRect SliderElement::subControlRect(const QStyleOptionComplex *option, QStyle::SubControl subControl, const QWidget *widget)
{
    Q_UNUSED(widget);
    const auto *sliderOpt = qstyleoption_cast<const QStyleOptionSlider *>(option);
    if (!sliderOpt)
        return QRect();

    QRect rect = option->rect;

    switch (subControl) {
    case QStyle::SC_SliderGroove: {
        if (sliderOpt->orientation == Qt::Horizontal) {
            rect.setHeight(Metrics::GrooveThickness);
            rect.moveCenter(QPoint(rect.center().x(), option->rect.center().y()));
        } else {
            rect.setWidth(Metrics::GrooveThickness);
            rect.moveCenter(QPoint(option->rect.center().x(), rect.center().y()));
        }
        return rect;
    }
    case QStyle::SC_SliderHandle: {
        const int handleSize = Metrics::SliderHandleSize;
        return QRect(0, 0, handleSize, handleSize);
    }
    default:
        break;
    }
    return QRect();
}

bool SliderElement::drawComplexControl(const QStyleOptionComplex *option, QPainter *painter, const QWidget *widget, const Helper *helper)
{
    Q_UNUSED(widget);
    Q_UNUSED(helper);

    const auto *sliderOpt = qstyleoption_cast<const QStyleOptionSlider *>(option);
    if (!sliderOpt)
        return false;

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    // Handle
    QRect handleRect = subControlRect(option, QStyle::SC_SliderHandle, widget);
    const int availableSpan = (sliderOpt->orientation == Qt::Horizontal ? option->rect.width() : option->rect.height()) - Metrics::SliderHandleSize;
    int sliderPos = QStyle::sliderPositionFromValue(sliderOpt->minimum, sliderOpt->maximum, sliderOpt->sliderPosition, availableSpan, sliderOpt->upsideDown);

    if (sliderOpt->orientation == Qt::Horizontal) {
        handleRect.moveLeft(option->rect.left() + sliderPos);
        handleRect.moveCenter(QPoint(handleRect.center().x(), option->rect.center().y()));
    } else {
        handleRect.moveTop(option->rect.top() + sliderPos);
        handleRect.moveCenter(QPoint(option->rect.center().x(), handleRect.center().y()));
    }

    // Groove
    if (sliderOpt->subControls & QStyle::SC_SliderGroove) {
        QRect grooveRect = subControlRect(option, QStyle::SC_SliderGroove, widget);

        QColor grooveColor = option->palette.color(QPalette::WindowText);
        grooveColor.setAlphaF(0.2);
        painter->setPen(Qt::NoPen);
        painter->setBrush(grooveColor);
        painter->drawRoundedRect(grooveRect, Metrics::TrackRadius, Metrics::TrackRadius);

        QRect activeRect = grooveRect;
        activeRect.setHeight(Metrics::TrackThickness);
        activeRect.moveCenter(QPoint(activeRect.center().x(), option->rect.center().y()));

        if (sliderOpt->orientation == Qt::Horizontal) {
            activeRect.setRight(handleRect.center().x());
        } else {
            activeRect.setTop(handleRect.center().y());
        }

        painter->setBrush(option->palette.color(QPalette::Highlight));
        painter->drawRoundedRect(activeRect, Metrics::TrackRadius, Metrics::TrackRadius);
    }

    // Slider Indicator
    if (sliderOpt->subControls & QStyle::SC_SliderHandle) {
        const bool isHover = option->state & QStyle::State_MouseOver;
        const QColor highlightColor = option->palette.color(QPalette::Highlight);

        painter->setPen(QPen(highlightColor, isHover ? 2 : 1.5));
        painter->setBrush(isHover ? highlightColor : option->palette.color(QPalette::Window));
        painter->drawEllipse(handleRect);
    }

    painter->restore();
    return true;
}

} // namespace Vinyl
