/**
 * @file vinylprogressbar.h
 * @brief ProgressBar element rendering interface.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#pragma once

#include <QPainter>
#include <QStyleOption>

namespace Vinyl
{

class Helper;

class ProgressBarElement
{
public:
    static QRect subElementRect(int element, const QStyleOption *option, const QWidget *widget);
    static bool drawControl(int element, const QStyleOption *option, QPainter *painter, const QWidget *widget, const Helper *helper);
};

} // namespace Vinyl
