/*
 * SPDX-FileCopyrightText: 2014 Hugo Pereira Da Costa <hugo.pereira@free.fr>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "vinylgenericdata.h"

namespace Vinyl
{
//______________________________________________
GenericData::GenericData(QObject *parent, QObject *target, int duration)
    : AnimationData(parent, target)
    , _animation(new Animation(duration, this))
    , _opacity(0)
{
    setupAnimation(_animation, "opacity");
}

}
