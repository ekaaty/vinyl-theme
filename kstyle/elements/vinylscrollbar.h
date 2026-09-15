/**
 * @file vinylscrollbar.h
 * @brief ScrollBar element rendering for the Vinyl theme.
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

class ScrollBarElement
{
public:
    static bool drawComplexControl(const QStyleOptionComplex *option, QPainter *painter, const QWidget *widget, const Helper *helper);
    static QRect subControlRect(const QStyleOptionComplex *option, QStyle::SubControl subControl, const QWidget *widget);
};
} // namespace Vinyl
