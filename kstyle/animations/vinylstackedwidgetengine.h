//////////////////////////////////////////////////////////////////////////////
// vinylstackedwidgetengine.h
// stores event filters and maps widgets to animations
// -------------------
//
// SPDX-FileCopyrightText: 2009 Hugo Pereira Da Costa <hugo.pereira@free.fr>
//
// SPDX-License-Identifier: MIT
//////////////////////////////////////////////////////////////////////////////

#pragma once

#include "vinylbaseengine.h"
#include "vinyldatamap.h"
#include "vinylstackedwidgetdata.h"

namespace Vinyl
{
//* used for simple widgets
class StackedWidgetEngine : public BaseEngine
{
    Q_OBJECT

public:
    //* constructor
    explicit StackedWidgetEngine(QObject *parent)
        : BaseEngine(parent)
    {
    }

    //* register widget
    bool registerWidget(QStackedWidget *);

    //* duration
    void setEnabled(bool value) override
    {
        BaseEngine::setEnabled(value);
        _data.setEnabled(value);
    }

    //* duration
    void setDuration(int value) override
    {
        BaseEngine::setDuration(value);
        _data.setDuration(value);
    }

public Q_SLOTS:

    //* remove widget from map
    bool unregisterWidget(QObject *object) override
    {
        return _data.unregisterWidget(object);
    }

private:
    //* maps
    DataMap<StackedWidgetData> _data;
};

}
