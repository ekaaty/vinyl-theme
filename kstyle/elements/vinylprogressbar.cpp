/**
 * @file vinylprogressbar.cpp
 * @brief ProgressBar element rendering implementation.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "vinylprogressbar.h"
#include "../vinylhelper.h"
#include "../vinylmetrics.h"
#include <QStyleOptionProgressBar>

namespace Vinyl
{

QRect ProgressBarElement::subElementRect(int element, const QStyleOption *option, const QWidget *widget)
{
    Q_UNUSED(widget);
    const auto *barOpt = qstyleoption_cast<const QStyleOptionProgressBar *>(option);
    if (!barOpt)
        return QRect();

    QRect rect = option->rect;

    if (barOpt->textVisible && !barOpt->text.isEmpty()) {
        const int fontMetricsWidth = option->fontMetrics.horizontalAdvance(barOpt->text) + 8;

        switch (element) {
        case QStyle::SE_ProgressBarLabel:
            return QRect(rect.right() - fontMetricsWidth, rect.top(), fontMetricsWidth, rect.height());
        case QStyle::SE_ProgressBarContents:
        case QStyle::SE_ProgressBarGroove:
            rect.setRight(rect.right() - fontMetricsWidth - 4);
            return rect;
        default:
            break;
        }
    }

    return rect;
}

bool ProgressBarElement::drawControl(int element, const QStyleOption *option, QPainter *painter, const QWidget *widget, const Helper *helper)
{
    Q_UNUSED(widget);
    Q_UNUSED(helper);

    const auto *barOpt = qstyleoption_cast<const QStyleOptionProgressBar *>(option);
    if (!barOpt)
        return false;

    const bool isHorizontal = (barOpt->state & QStyle::State_Horizontal);
    const QRect contentRect = subElementRect(QStyle::SE_ProgressBarContents, option, widget);

    QRect grooveRect = contentRect;
    QRect highlightRect = contentRect;

    if (isHorizontal) {
        grooveRect.setHeight(Metrics::GrooveThickness);
        grooveRect.moveCenter(QPoint(grooveRect.center().x(), contentRect.center().y()));

        highlightRect.setHeight(Metrics::TrackThickness);
        highlightRect.moveCenter(QPoint(highlightRect.center().x(), contentRect.center().y()));
    } else {
        grooveRect.setWidth(Metrics::GrooveThickness);
        grooveRect.moveCenter(QPoint(contentRect.center().x(), grooveRect.center().y()));

        highlightRect.setWidth(Metrics::TrackThickness);
        highlightRect.moveCenter(QPoint(contentRect.center().x(), highlightRect.center().y()));
    }

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    switch (element) {
    case QStyle::CE_ProgressBarGroove: {
        QColor grooveColor = option->palette.color(QPalette::WindowText);
        grooveColor.setAlphaF(0.2);

        painter->setPen(Qt::NoPen);
        painter->setBrush(grooveColor);
        painter->drawRoundedRect(grooveRect, Metrics::TrackRadius, Metrics::TrackRadius);
        break;
    }
    case QStyle::CE_ProgressBarContents: {
        const double progress = static_cast<double>(barOpt->progress - barOpt->minimum) / std::max(1, barOpt->maximum - barOpt->minimum);

        QRect progressRect = highlightRect;
        if (isHorizontal) {
            progressRect.setWidth(static_cast<int>(highlightRect.width() * progress));
        } else {
            int fillHeight = static_cast<int>(highlightRect.height() * progress);
            progressRect.setTop(highlightRect.bottom() - fillHeight);
        }

        painter->setPen(Qt::NoPen);
        painter->setBrush(option->palette.color(QPalette::Highlight));
        painter->drawRoundedRect(progressRect, Metrics::TrackRadius, Metrics::TrackRadius);
        break;
    }
    case QStyle::CE_ProgressBarLabel: {
        if (barOpt->textVisible && !barOpt->text.isEmpty()) {
            const QRect labelRect = subElementRect(QStyle::SE_ProgressBarLabel, option, widget);
            painter->setPen(option->palette.color(QPalette::Text));
            painter->drawText(labelRect, Qt::AlignRight | Qt::AlignVCenter, barOpt->text);
        }
        break;
    }
    case QStyle::CE_ProgressBar: {
        drawControl(QStyle::CE_ProgressBarGroove, option, painter, widget, helper);
        drawControl(QStyle::CE_ProgressBarContents, option, painter, widget, helper);
        if (barOpt->textVisible) {
            drawControl(QStyle::CE_ProgressBarLabel, option, painter, widget, helper);
        }
        break;
    }
    default:
        painter->restore();
        return false;
    }

    painter->restore();
    return true;
}

} // namespace Vinyl
