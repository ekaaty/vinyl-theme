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
#include <algorithm>

namespace Vinyl
{

QRect ProgressBarElement::subElementRect(int element, const QStyleOption *option, const QWidget *widget)
{
    Q_UNUSED(widget);

    const auto *barOpt = qstyleoption_cast<const QStyleOptionProgressBar *>(option);
    if (!barOpt)
        return QRect();

    QRect rect = option->rect;

    int textWidth = 0;
    if (barOpt->textVisible && !barOpt->text.isEmpty()) {
        textWidth = option->fontMetrics.horizontalAdvance(barOpt->text) + 8;
    }

    switch (element) {
    case QStyle::SE_ProgressBarLabel:
        if (textWidth > 0) {
            return QRect(rect.right() - textWidth + 1, rect.top(), textWidth, rect.height());
        }
        return QRect();

    case QStyle::SE_ProgressBarGroove:
        if (textWidth > 0) {
            rect.setRight(rect.right() - textWidth);
        }
        return rect;

    case QStyle::SE_ProgressBarContents: {
        if (textWidth > 0) {
            rect.setRight(rect.right() - textWidth);
        }

        const qint64 span = barOpt->maximum - barOpt->minimum;
        if (span <= 0) {
            return rect;
        }

        const double ratio = static_cast<double>(barOpt->progress - barOpt->minimum) / static_cast<double>(span);
        const double clampedRatio = std::clamp(ratio, 0.0, 1.0);

        const bool isHorizontal = (barOpt->state & QStyle::State_Horizontal);
        if (isHorizontal) {
            rect.setWidth(static_cast<int>(rect.width() * clampedRatio));
        } else {
            const int fillHeight = static_cast<int>(rect.height() * clampedRatio);
            rect.setTop(rect.bottom() - fillHeight + 1);
        }
        return rect;
    }
        default:
            break;
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

    switch (element) {
    case QStyle::CE_ProgressBarGroove: {
        painter->save();
        painter->setRenderHint(QPainter::Antialiasing);

        QColor grooveColor = option->palette.color(QPalette::WindowText);
        grooveColor.setAlphaF(0.2);

        QRect grooveRect = option->rect;
        grooveRect.setHeight(Metrics::GrooveThickness);
        grooveRect.moveCenter(QPoint(grooveRect.center().x(), option->rect.center().y()));

        painter->setPen(Qt::NoPen);
        painter->setBrush(grooveColor);
        painter->drawRoundedRect(grooveRect, Metrics::TrackRadius, Metrics::TrackRadius);

        painter->restore();
        return true;
    }
    case QStyle::CE_ProgressBarContents: {
        painter->save();
        painter->setRenderHint(QPainter::Antialiasing);

        QRect contentsRect = option->rect;
        if (contentsRect.width() <= 0 || contentsRect.height() <= 0) {
            painter->restore();
            return true;
        }

        const bool isHorizontal = (barOpt->state & QStyle::State_Horizontal);
        if (isHorizontal) {
            contentsRect.setHeight(Metrics::TrackThickness);
            contentsRect.moveCenter(QPoint(contentsRect.center().x(), option->rect.center().y()));
        } else {
            contentsRect.setWidth(Metrics::TrackThickness);
            contentsRect.moveCenter(QPoint(option->rect.center().x(), contentsRect.center().y()));
        }

        const QColor contentsColor =
            option->state.testFlag(QStyle::State_Selected) ? option->palette.color(QPalette::HighlightedText) : option->palette.color(QPalette::Highlight);

        painter->setPen(Qt::NoPen);
        painter->setBrush(contentsColor);
        painter->drawRoundedRect(contentsRect, Metrics::TrackRadius, Metrics::TrackRadius);

        painter->restore();
        return true;
    }
    case QStyle::CE_ProgressBarLabel: {
        if (barOpt->textVisible && !barOpt->text.isEmpty()) {
            painter->save();
            painter->setPen(option->palette.color(QPalette::Text));
            painter->drawText(option->rect, Qt::AlignRight | Qt::AlignVCenter, barOpt->text);
            painter->restore();
        }
        return true;
    }
    case QStyle::CE_ProgressBar:
    default: {
        QStyleOptionProgressBar optCopy = *barOpt;

        optCopy.rect = subElementRect(QStyle::SE_ProgressBarGroove, barOpt, widget);
        drawControl(QStyle::CE_ProgressBarGroove, &optCopy, painter, widget, helper);

        optCopy.rect = subElementRect(QStyle::SE_ProgressBarContents, barOpt, widget);
        drawControl(QStyle::CE_ProgressBarContents, &optCopy, painter, widget, helper);

        if (barOpt->textVisible) {
            optCopy.rect = subElementRect(QStyle::SE_ProgressBarLabel, barOpt, widget);
            drawControl(QStyle::CE_ProgressBarLabel, &optCopy, painter, widget, helper);
        }
        return true;
    }
    }
}

} // namespace Vinyl
