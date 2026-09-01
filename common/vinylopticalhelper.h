/**
 * @file vinylopticalhelper.h
 * @brief Implementation of the Vinyl optical helper.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-3.0-only
 */

#ifndef VINYL_OPTICAL_HELPER_H
#define VINYL_OPTICAL_HELPER_H

#include <QColor>
#include <algorithm>

namespace Vinylnx {
    // Direct link with math functions from Rust library
    extern "C" {
        float calculate_vinyl_sheen(float dist, float intensity, float plasticity);
        float generate_micro_texture(int x, int y, unsigned int seed);
    }

    class OpticalHelper {
    public:
        // Returns the specular highlight color (Sheen) for phisical edges
        static QColor computeSheenColor(const QColor &base, float dist, float intensity, float plasticity) {
            float alpha = calculate_vinyl_sheen(dist, intensity, plasticity);
            QColor color = base;
            color.setAlphaF(std::clamp(alpha, 0.0f, 1.0f));
            return color;
        }

        // Returns tactil noise factor for manual dither
        static float getSurfaceGrain(int x, int y, unsigned int seed) {
            return generate_micro_texture(x, y, seed);
        }
    };
}

#endif
