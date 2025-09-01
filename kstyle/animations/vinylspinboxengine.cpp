/*
 * SPDX-FileCopyrightText: 2014 Hugo Pereira Da Costa <hugo.pereira@free.fr>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "vinylspinboxengine.h"

#include <QEvent>

namespace Vinyl
{
//____________________________________________________________
bool SpinBoxEngine::registerWidget(QObject *target)
{
    if (!target) {
        return false;
    }

    // create new data class
    if (!_data.contains(target)) {
        _data.insert(target, new SpinBoxData(this, target, duration()), enabled());
    }

    // connect destruction signal
    connect(target, &QObject::destroyed, this, &SpinBoxEngine::unregisterWidget, Qt::UniqueConnection);
    return true;
}

}
