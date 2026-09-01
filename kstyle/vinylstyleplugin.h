/**
 * @file vinylstyleplugin.h
 * @brief Plugin factory for the Vinyl theme.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#pragma once

#include <QStylePlugin>

namespace Vinyl
{
    /**
     * @class StylePlugin
     * @brief Factory class to instantiate the Vinyl Style.
     * * This class implements the QStyleFactoryInterface, allowing the system
     * to discover and load "vinylnx" as a selectable theme.
     */
    class StylePlugin : public QStylePlugin
    {
        Q_OBJECT
        Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QStyleFactoryInterface" FILE "vinylnx.json")

    public:
        /**
         * @brief Constructor.
         */
        explicit StylePlugin(QObject *parent = nullptr)
            : QStylePlugin(parent)
        {
        }

        /**
         * @brief Returns the list of style keys supported by this plugin.
         * @return A list containing "vinylnx".
         */
        QStringList keys() const;

        /**
         * @brief Factory method to create the Vinyl style instance.
         * @param key The name of the style to create.
         * @return A new Style instance if the key matches, nullptr otherwise.
         */
        QStyle *create(const QString &key) override;
    };

}
