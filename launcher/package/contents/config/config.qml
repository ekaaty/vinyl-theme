/*
 * SPDX-FileCopyrightText: 2024 Christian Tosta <christian.tosta@gmail.com>
 * SPDX-FileCopyrightText: 2014 Eike Hein <hein@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import org.kde.plasma.configuration

ConfigModel {
  ConfigCategory {
    name: i18nd("plasma_applet_org.kde.plasma.kicker", "General")
    icon: "preferences-system"
    source: "ConfigGeneral.qml"
  }
}

// vim: ts=2:sw=2:sts=2:et
