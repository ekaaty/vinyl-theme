/**
 * @file vinylhelper.cpp
 * @brief Implementation of style helper class for the Vinyl theme.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#include "vinylhelper.h"

#include <QPainter>
#include <QStyleOptionButton>
#include <QAbstractButton>
#include <QApplication>

#include "elements/vinylbuttonprimitive.h"
#include "elements/vinylbuttoncontrol.h"
#include "elements/vinylcomboboxprimitive.h"
#include "elements/vinylcomboboxcontrol.h"
#include "elements/vinylcomboboxcomplex.h"
#include "elements/vinylframeprimitive.h"


namespace Vinyl
{
    // =================================================================
    // CONSTRUCTOR / DESTRUCTOR
    // =================================================================

    Helper::Helper(KSharedConfig::Ptr config, QStyle* baseStyle)
        : Breeze::Helper(config), _baseStyle(baseStyle)
    {}

    // =================================================================
    // WIDGET RENDERING DELEGATES
    // =================================================================

    // PRIMITIVE (PE_*) - Átomos (Mapeado da Stable)
    // =====================================================================
    bool Helper::vinylDrawPrimitive(const QStyleOption* option, QPainter* painter,
                                    const QWidget* widget, int element) const
    {
        switch (element) {

            // FAMILY: BUTTONS
            case QStyle::PE_PanelButtonCommand:             return
                ButtonPrimitive::drawPanelButtonCommand(option, painter, widget, this);
            case QStyle::PE_PanelButtonTool:                return
                ButtonPrimitive::drawPanelButtonTool(option, painter, widget, this);

            // FAMILY: SYSTEM / NAVIGATION
            case QStyle::PE_PanelScrollAreaCorner:          break;
            case QStyle::PE_PanelMenu:                      break;
            case QStyle::PE_PanelMenuBar:                   break; // stable: emptyPrimitive
            case QStyle::PE_PanelTipLabel:                  break;
            case QStyle::PE_PanelItemViewItem:              break;
            case QStyle::PE_PanelStatusBar:                 break;

            // FAMILY: INDICATORS
            case QStyle::PE_IndicatorButtonDropDown:        return
                ButtonPrimitive::drawIndicatorButtonDropDown(option, painter, widget, this);
            case QStyle::PE_IndicatorCheckBox:              break;
            case QStyle::PE_IndicatorRadioButton:           break;
            case QStyle::PE_IndicatorTabClose:              break;
            case QStyle::PE_IndicatorTabTear:               break;
            case QStyle::PE_IndicatorBranch:                break;
            case QStyle::PE_IndicatorToolBarHandle:         break;
            case QStyle::PE_IndicatorToolBarSeparator:      break;

            // FAMILY: ARROWS
            case QStyle::PE_IndicatorArrowUp:               break;
            case QStyle::PE_IndicatorArrowDown:             break;
            case QStyle::PE_IndicatorArrowLeft:             break;
            case QStyle::PE_IndicatorArrowRight:            break;
            case QStyle::PE_IndicatorHeaderArrow:           break;

            // FAMILY: FRAMES
            case QStyle::PE_Frame:                          break;
            case QStyle::PE_FrameLineEdit:                  return
                FramePrimitive::drawFrameLineEdit(element, option, painter, widget, this);
            case QStyle::PE_FrameMenu:                      break;
            case QStyle::PE_FrameGroupBox:                  return true;
            case QStyle::PE_FrameTabWidget:                 return true;
            case QStyle::PE_FrameTabBarBase:                break;
            case QStyle::PE_FrameWindow:                    break;
            case QStyle::PE_FrameStatusBarItem:             break; // stable: emptyPrimitive
            case QStyle::PE_FrameFocusRect:                 break;

            default: break;
        }
        return false;
    }

    // CONTROL (CE_*) - Moléculas (Mapeado da Stable)
    // =====================================================================
    bool Helper::vinylDrawControl(const QStyleOption* option, QPainter* painter,
                                  const QWidget* widget, int element) const
    {
        switch (element) {
            // FAMILY: BUTTONS
            case QStyle::CE_PushButton:
                ButtonPrimitive::drawPanelButtonCommand(option, painter, widget, this);
                ButtonControl::drawPushButtonLabel(option, painter, widget, this);
                return true;
            case QStyle::CE_PushButtonLabel:
                return ButtonControl::drawPushButtonLabel(option, painter, widget, this);
            case QStyle::CE_ToolButtonLabel:     break;

            // FAMILY: INDICATORS (Labels)
            case QStyle::CE_CheckBoxLabel:       break;
            case QStyle::CE_RadioButtonLabel:    break;
                // return IndicatorControl::draw(element, option, painter, widget, this);

            // FAMILY: INPUTS (Labels)
            case QStyle::CE_ComboBoxLabel:       return true; // handled by CC_ComboBox

            // FAMILY: MENU / NAVIGATION
            case QStyle::CE_MenuBarEmptyArea:    break;
            case QStyle::CE_MenuBarItem:         break;
            case QStyle::CE_MenuItem:            break;
                // return MenuControl::draw(element, option, painter, widget, this);

            // FAMILY: PROGRESS
            case QStyle::CE_ProgressBar:         break;
            case QStyle::CE_ProgressBarContents: break;
            case QStyle::CE_ProgressBarGroove:   break;
            case QStyle::CE_ProgressBarLabel:    break;
                // return ProgressControl::draw(element, option, painter, widget, this);

            // FAMILY: SCROLL
            case QStyle::CE_ScrollBarSlider:     break;
            case QStyle::CE_ScrollBarAddLine:    break;
            case QStyle::CE_ScrollBarSubLine:    break;
            case QStyle::CE_ScrollBarAddPage:    break; // stable: emptyControl
            case QStyle::CE_ScrollBarSubPage:    break; // stable: emptyControl
                // return ScrollControl::draw(element, option, painter, widget, this);

            // FAMILY: TABS
            case QStyle::CE_TabBarTabLabel:      break;
            case QStyle::CE_TabBarTabShape:      break;
            case QStyle::CE_ToolBoxTabLabel:     break;
            case QStyle::CE_ToolBoxTabShape:     break;
                // return TabsControl::draw(element, option, painter, widget, this);

            // FAMILY: SYSTEM / FRAMES
            case QStyle::CE_ToolBar:             break;
            case QStyle::CE_ShapedFrame:         break;
            case QStyle::CE_RubberBand:          break;
            case QStyle::CE_SizeGrip:            break; // stable: emptyControl
            case QStyle::CE_HeaderSection:       break;
            case QStyle::CE_HeaderEmptyArea:     break;
            case QStyle::CE_DockWidgetTitle:     break;
                // return SystemControl::draw(element, option, painter, widget, this);

           default: break;
        }
        return false;
    }

    // COMPLEX (CC_*) - Organismos (Mapeado da Stable)
    // =====================================================================
    bool Helper::vinylDrawComplexControl(const QStyleOptionComplex* option, QPainter* painter,
                                         const QWidget* widget, int element) const
    {
        Q_UNUSED(option);
        Q_UNUSED(painter);
        Q_UNUSED(widget);

        switch (element) {

            // FAMILY: BUTTONS
            case QStyle::CC_ToolButton:                     break;
            // FAMILY: FRAMES
            case QStyle::CC_GroupBox:                       break;
            // FAMILY: INPUTS
            case QStyle::CC_ComboBox:                       return
                ComboBoxComplex::drawComboBoxComplexControl(option, painter, widget, this);
            case QStyle::CC_SpinBox:                        break;
            // FAMILY: SLIDERS / DIALS
            case QStyle::CC_Slider:                         break;
            case QStyle::CC_Dial:                           break;
            // FAMILY: SCROLL
            case QStyle::CC_ScrollBar:                      break;
            // FAMILY: SYSTEM
            case QStyle::CC_TitleBar:                       break;

            default: break;
        }

        return false;
    }

    void Helper::drawBackgroundPrimitive(const QStyleOption* option, QPainter* painter) const
    {
        const qreal radius = 4.0;

        const bool enabled = option->state & QStyle::State_Enabled;
        const bool mouseOver = option->state & QStyle::State_MouseOver;
        const bool hasFocus = option->state & QStyle::State_HasFocus;
        const bool sunken = option->state & QStyle::State_Sunken;
        const bool on = option->state & QStyle::State_On;

        QColor color;
        if (!enabled) {
            color = option->palette.color(QPalette::Disabled, QPalette::Button);
        } else if (on || sunken || mouseOver || hasFocus) {
            color = option->palette.color(QPalette::Highlight);
        } else {
            color = option->palette.color(QPalette::Button);
        }

        qreal alpha = enabled ? (sunken || hasFocus ? 0.9 : 0.6) : 0.3;
        color.setAlphaF(alpha);

        painter->save();
        painter->setRenderHint(QPainter::Antialiasing);
        painter->setPen(Qt::NoPen);
        painter->setBrush(color);
        painter->drawRoundedRect(option->rect, radius, radius);
        painter->restore();
    }

    void Helper::drawBorderPrimitive(const QStyleOption* option, QPainter* painter) const
    {
        const qreal radius = 4.0;
        const QRectF frameRect = QRectF(option->rect).adjusted(0.5, 0.5, -0.5, -0.5);

        const bool enabled = option->state & QStyle::State_Enabled;
        const bool mouseOver = option->state & QStyle::State_MouseOver;
        const bool hasFocus = option->state & QStyle::State_HasFocus;

        const bool isDark = option->palette.color(QPalette::Window).value() < 128;
        QColor color = isDark ? Qt::white : Qt::black;

        qreal alpha = 0.9;
        qreal width = 1.0;

        if (enabled &&(mouseOver || hasFocus)) {
            color = option->palette.color(QPalette::Highlight);
            alpha = hasFocus ? 0.9 : 0.6;
            width = hasFocus ? 2.0 : 1.0;
        } else {
            alpha = 0.05;
        }

        color.setAlphaF(alpha);

        painter->save();
        painter->setRenderHint(QPainter::Antialiasing);
        painter->setBrush(Qt::NoBrush);
        painter->setPen(QPen(color, width));
        painter->drawRoundedRect(frameRect, radius, radius);
        painter->restore();
    }

    void Helper::drawIconPrimitive(QPainter *painter, const QRect &rect, 
                                   const QStyleOption *option, const QIcon &icon,
                                   const QSize &iconSize) const
    {
        if (icon.isNull() || iconSize.isEmpty()) return;

        painter->save();

        const bool enabled = option->state & QStyle::State_Enabled;
        const bool active = option->state & QStyle::State_Active;

        // Set half opacity if disabled
        painter->setOpacity(enabled ? 1.0 : 0.5);

        // Calculate icon position
        int yPos = rect.top() + (rect.height() - iconSize.height()) / 2;
        int xPos = (option->direction == Qt::RightToLeft) 
                   ? (rect.right() - iconSize.width()) 
                   : rect.left();               
        QRect iconRect(xPos, yPos, iconSize.width(), iconSize.height());

        // Render with correct icon mode
        QIcon::Mode mode = enabled ? (active ? QIcon::Active : QIcon::Normal) : QIcon::Disabled;
        icon.paint(painter, iconRect, Qt::AlignCenter, mode);

        painter->restore();
    }

    void Helper::drawTextPrimitive(QPainter *painter, const QRect &rect, const QStyleOption *option,
                                   const QString &text, Qt::Alignment alignment) const
    {
        if (text.isEmpty()) return;

        const QStyle::State &state = option->state;
        const bool enabled = state & QStyle::State_Enabled;
        Qt::Alignment absoluteAlign = QStyle::visualAlignment(option->direction, alignment);

        painter->save();

        // Color based on state
        QPalette::ColorRole textRole = (state & (QStyle::State_Sunken | QStyle::State_On)) 
                                       ? QPalette::HighlightedText 
                                       : QPalette::ButtonText;
        
        painter->setPen(option->palette.color(textRole));

        // Set half opacity if disabled
        painter->setOpacity(enabled ? 1.0 : 0.5);

        // Metrics and ellipse
        const QFontMetrics fm(painter->font());
        const QString elidedText = fm.elidedText(text, Qt::ElideRight, rect.width());

        // Manual positioning to avoid QStyle interference
        int yPos = rect.top() + (rect.height() - fm.height()) / 2 + fm.ascent();
        int xPos = rect.left();

        if (absoluteAlign & Qt::AlignHCenter) {
            xPos = rect.left() + (rect.width() - fm.horizontalAdvance(elidedText)) / 2;
        } else if (absoluteAlign & Qt::AlignRight) {
            xPos = rect.right() - fm.horizontalAdvance(elidedText);
        }

        painter->drawText(xPos, yPos, elidedText);

        painter->restore();
    }


} // namespace Vinyl
