/**
 * @file vinylstyleplugin.cpp
 * @brief Implementation of the Vinyl style plugin factory.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylstyleplugin.h"
#include "vinylstyle.h"

#include <QApplication>

namespace Vinyl
{
    // =================================================================
    // PLUGIN INTERFACE IMPLEMENTATION
    // =================================================================

    QStyle *StylePlugin::create(const QString &key)
    {
        if (key.compare(QLatin1String("vinylnx"), Qt::CaseInsensitive) == 0) {
            return new Style;
        }
        return nullptr;
    }

    QStringList StylePlugin::keys() const
    {
        return QStringList(QStringLiteral("vinylnx"));
    }

}
