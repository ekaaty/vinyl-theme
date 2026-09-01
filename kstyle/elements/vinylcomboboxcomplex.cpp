/**
 * @file vinylcomboboxcomplex.cpp
 * @brief Implementation of complex combobox rendering for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */


#include "vinylcomboboxcomplex.h"
#include "vinylcomboboxprimitive.h"
#include "vinylcomboboxcontrol.h"
#include "vinylbuttonprimitive.h"
#include "vinylhelper.h"

#include <QStyleOptionComboBox>
#include <QPainter>

namespace Vinyl
{

    bool ComboBoxComplex::drawComboBoxComplexControl(const QStyleOptionComplex* option, QPainter* painter,
                                                     const QWidget* widget, const Helper* helper)
    {
        const auto cb = qstyleoption_cast<const QStyleOptionComboBox*>(option);
        if (!cb) return false;

        // Draw the frame
        ComboBoxPrimitive::drawPanelComboBox(option, painter, widget, helper);

        // Draw the content (Text/Icon)
        ComboBoxControl::drawComboBoxLabel(option, painter, widget, helper);

        // Draw the arrow
        if (cb->subControls & QStyle::SC_ComboBoxArrow)
        {
            // Create a copy to isolate only arrow geometry
            //QStyleOptionComplex arrowOption = *cb;
            QStyleOption arrowOption;
            arrowOption.palette = cb->palette;
            arrowOption.state = cb->state;
            
            // Get the specific arrow sub-control area
            arrowOption.rect = helper->subControlRect(QStyle::CC_ComboBox, cb,
                                                      QStyle::SC_ComboBoxArrow, widget);
            
            // Moves the arrow area a bit away from right border edge
            arrowOption.rect.translate(-2, 0);

            // Reuse Dropdown ToolButtons logic to draw the arrow
            ButtonPrimitive::drawIndicatorButtonDropDown(&arrowOption, painter, widget, helper);

            //QRectF arrowRect = arrowOption.rect;
            //helper->renderArrow(painter, arrowRect, QPalette::ButtonText, Breeze::ArrowDown);
        }

        return true;
    }

} // namespace Vinyl
