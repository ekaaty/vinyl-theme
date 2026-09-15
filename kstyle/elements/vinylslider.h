/**
 * @file vinylslider.h
 * @brief Slider element rendering for the Vinyl theme.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#pragma once

#include <QPainter>
#include <QStyleOptionComplex>
#include <QWidget>

namespace Vinyl
{
class Helper;

class SliderElement
{
public:
    static bool drawComplexControl(const QStyleOptionComplex *option, QPainter *painter, const QWidget *widget, const Helper *helper);
    static QRect subControlRect(const QStyleOptionComplex *option, QStyle::SubControl subControl, const QWidget *widget);
};
} // namespace Vinyl
