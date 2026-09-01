/**
 * @file vinyltypes.h
 * @brief Global definitions and constants for the Vinyl style.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */
#ifndef VINYLTYPES_H
#define VINYLTYPES_H

namespace Vinyl {

    /**
     * @brief Internal classification of elements.
     * Useful for logging, debugging, or specific logic inside the Helper
     * that needs to know which "family" a call belongs to.
     */
    enum class ElementType {
        Primitive = 1,
        Control = 2,
        ComplexControl = 3
    };

}

#endif // VINYLTYPES_H
