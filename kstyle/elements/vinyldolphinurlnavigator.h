/**
 * @file vinyldolphinurlnavigator.h
 * @brief Header for DolphinUrlNavigator custom rendering in the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLDOLPHINURLNAVIGATOR_H
#define VINYLDOLPHINURLNAVIGATOR_H

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

#endif // VINYLDOLPHINURLNAVIGATOR_H
