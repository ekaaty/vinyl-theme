/**
 * @file vinylmetrics.h
 * @brief Centralized design tokens and metrics for the Vinyl theme.
 *
 * SPDX-FileCopyrightText: 2026 Christian Tosta
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#pragma once

namespace Vinyl::Metrics
{

// Trailer Components (ScrollBar, Slider and ProgressBar)
inline constexpr int TrackThickness = 4;
inline constexpr int GrooveThickness = 2;
inline constexpr int TrackRadius = 3;

// Sliders
inline constexpr int SliderHandleSize = 14;
inline constexpr int SliderHandleRadius = 7;

// ScrollBars
inline constexpr int ScrollBarExtent = 8;
inline constexpr int ScrollBarMinSpace = 12;
inline constexpr int ScrollBarMargin = TrackThickness + 1;

// Borders and Default Geometry
inline constexpr int BorderWidth = 1;
inline constexpr int CornerRadius = 4;

// Tabs
inline constexpr int TabBarTabIndicatorThickness = 2;

} // namespace Vinyl::Metrics
