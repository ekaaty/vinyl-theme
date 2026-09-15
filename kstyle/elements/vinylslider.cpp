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

/**
 * @brief Calculates sub-control geometries for the slider component.
 * @param option Complex style option describing the slider state and metrics.
 * @param subControl Target sub-control element (e.g., groove, handle).
 * @param widget Pointer to the widget being rendered.
 * @return Bounding rectangle of the requested sub-control.
 */
QRect SliderElement::subControlRect(const QStyleOptionComplex *option, QStyle::SubControl subControl, const QWidget *widget)
{
    Q_UNUSED(widget);
    const auto *sliderOpt = qstyleoption_cast<const QStyleOptionSlider *>(option);
    if (!sliderOpt) {
        return QRect();
    }

    const int handleSize = Metrics::SliderHandleSize;
    const int handleRadius = Metrics::SliderHandleRadius;
    const int padding = 1; // Safety margin for pen stroke width
    QRect rect = option->rect;

    switch (subControl) {
    case QStyle::SC_SliderGroove: {
        if (sliderOpt->orientation == Qt::Horizontal) {
            rect.adjust(handleRadius, 0, -handleRadius, 0);
            rect.setHeight(Metrics::GrooveThickness);
            rect.moveCenter(QPoint(rect.center().x(), option->rect.center().y()));
        } else {
            rect.adjust(0, handleRadius, 0, -handleRadius);
            rect.setWidth(Metrics::GrooveThickness);
            rect.moveCenter(QPoint(option->rect.center().x(), rect.center().y()));
        }
        return rect;
    }
    case QStyle::SC_SliderHandle: {
        const bool isHoriz = (sliderOpt->orientation == Qt::Horizontal);

        // Available span deducts handle size and pen stroke padding
        const int availableLength = (isHoriz ? option->rect.width() : option->rect.height()) - handleSize - (2 * padding);

        const int pos = QStyle::sliderPositionFromValue(sliderOpt->minimum,
                                                        sliderOpt->maximum,
                                                        sliderOpt->sliderPosition,
                                                        std::max(0, availableLength),
                                                        sliderOpt->upsideDown);

        QRect handle(0, 0, handleSize, handleSize);
        if (isHoriz) {
            handle.moveLeft(option->rect.left() + padding + pos);
            handle.moveCenter(QPoint(handle.center().x(), option->rect.center().y()));
        } else {
            handle.moveTop(option->rect.top() + padding + pos);
            handle.moveCenter(QPoint(option->rect.center().x(), handle.center().y()));
        }
        return handle;
    }
    default:
        break;
    }
    return QRect();
}

/**
 * @brief Renders the slider complex control including groove, active fill, and handle.
 * @param option Complex style option describing slider state and geometry.
 * @param painter QPainter instance for rendering operations.
 * @param widget Pointer to the widget being rendered.
 * @param helper Pointer to design helper utility.
 * @return True if rendering was successful, false otherwise.
 */
bool SliderElement::drawComplexControl(const QStyleOptionComplex *option, QPainter *painter, const QWidget *widget, const Helper *helper)
{
    Q_UNUSED(widget);
    Q_UNUSED(helper);

    const auto *sliderOpt = qstyleoption_cast<const QStyleOptionSlider *>(option);
    if (!sliderOpt) {
        return false;
    }

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    const QRect grooveRect = subControlRect(option, QStyle::SC_SliderGroove, widget);
    const QRect handleRect = subControlRect(option, QStyle::SC_SliderHandle, widget);

    // Groove track
    if (sliderOpt->subControls & QStyle::SC_SliderGroove) {
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

    // Handle
    if (sliderOpt->subControls & QStyle::SC_SliderHandle) {
        const bool isHover = option->state & QStyle::State_MouseOver;
        const QColor highlightColor = option->palette.color(QPalette::Highlight);
        const qreal penWidth = isHover ? 2.0 : 1.5;

        painter->setPen(QPen(highlightColor, penWidth));
        painter->setBrush(isHover ? highlightColor : option->palette.color(QPalette::Window));

        // Adjust rectangle inward by half pen width to avoid clipping on boundaries
        const QRectF strokeRect = QRectF(handleRect).adjusted(penWidth / 2.0, penWidth / 2.0, -penWidth / 2.0, -penWidth / 2.0);
        painter->drawEllipse(strokeRect);
    }

    painter->restore();
    return true;
}

} // namespace Vinyl
