/**
 * @file vinylhelper.h
 * @brief Central mediator for the Vinyl style drawing operations.
 * * This class acts as the main router, dispatching draw calls from the
 * QStyle implementation to specific element families (Buttons, Tabs, etc.)
 * organized by their drawing category (Primitive, Control, Widget).
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYLHELPER_H
#define VINYLHELPER_H

#include "breezehelper.h"
#include <KSharedConfig>
#include <QPainter>
#include <QStyleOptionButton>

namespace Vinyl
{
    /**
     * @class Helper
     * @brief Provides a centralized interface for custom element rendering.
     * * The Helper class ensures that drawing logic is decoupled from the main
     * Style class, allowing for a modular and atomic architecture.
     */
    class Helper : public Breeze::Helper
    {
        Q_OBJECT

    public:
        /**
         * @brief Constructor that initializes the base Breeze::Helper.
         * @param config Pointer to the KDE shared configuration.
         */
        explicit Helper(KSharedConfig::Ptr config, QStyle* baseStyle = nullptr);

        void setProxy(QStyle* proxy) { _proxy = proxy; }
        QStyle* proxy() const { return _proxy; }
        QStyle* baseStyle() const { return _baseStyle; }

        /**
        * @brief Renders basic atoms and shapes (Primitive Elements).
        * @param option Style options (geometry, state, etc.).
        * @param painter The active QPainter for the device.
        * @param widget The widget being painted (may be null).
        * @param element The QStyle::PrimitiveElement ID.
        * @return true if the element was handled by Vinyl, false to fallback.
        */
        bool vinylDrawPrimitive(const QStyleOption *option, QPainter *painter,
                                const QWidget *widget, int element) const;

        /**
        * @brief Renders simple widget parts and labels (Control Elements).
        * @param option Style options.
        * @param painter The active QPainter.
        * @param widget The widget being painted.
        * @param element The QStyle::ControlElement ID.
        * @return true if handled, false otherwise.
        */
        bool vinylDrawControl(const QStyleOption *option, QPainter *painter,
                            const QWidget *widget, int element) const;

        /**
        * @brief Renders complex widgets with sub-controls (Complex Controls).
        * @param option Specialized style options for complex widgets.
        * @param painter The active QPainter.
        * @param widget The widget being painted.
        * @param element The QStyle::ComplexControl ID.
        * @return true if handled, false otherwise.
        */
        bool vinylDrawComplexControl(const QStyleOptionComplex *option, QPainter *painter,
                                     const QWidget *widget, int element) const;


        /**
         * @brief Calculates the rectangle for a specific sub-control of a complex widget.
         * @param cc The complex control type (e.g., CC_ComboBox).
         * @param opt The style options for the complex control.
         * @param sc The specific sub-control (e.g., SC_ComboBoxArrow).
         * @param widget The widget being queried.
         * @return The bounding rectangle of the sub-control in widget coordinates.
         */
        QRect subControlRect(QStyle::ComplexControl cc, const QStyleOptionComplex* opt,
                             QStyle::SubControl sc, const QWidget* widget) const 
        {
            if (widget && widget->style()) {
                return widget->style()->subControlRect(cc, opt, sc, widget);
            }
            return QRect(); // Or fallback logic
        }

        void drawBackgroundPrimitive(const QStyleOption* option, QPainter* painter) const;
        void drawBorderPrimitive(const QStyleOption *option, QPainter* painter) const;
        void drawIconPrimitive(QPainter *painter, const QRect &rect, const QStyleOption *option,
                               const QIcon &icon, const QSize &iconSize) const;
        void drawTextPrimitive(QPainter *painter, const QRect &rect, const QStyleOption *option, 
                               const QString &text, Qt::Alignment alignment = Qt::AlignLeft | Qt::AlignVCenter) const;

    private:
        QStyle* _baseStyle = nullptr;
        QStyle* _proxy = nullptr;
    };
}

#endif
