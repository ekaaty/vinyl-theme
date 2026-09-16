/**
 * @file vinylbreadcrumbs.h
 * @brief Header for Breadcrumbs rendering in the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLBREADCRUMBS_H
#define VINYLBREADCRUMBS_H

#include <QPainter>
#include <QStyleOption>
#include <QWidget>

namespace Vinyl
{
class DolphinUrlNavigator
{
public:
    /**
     * @brief Draws the DolphinUrlNavigator background and palette overrides.
     * @return true if the event was handled, false to fall back to default rendering.
     */
    static bool draw(const QStyleOption *option, QPainter *painter, const QWidget *widget);
};

} // namespace Vinyl

#endif // VINYLBREADCRUMBS_H
