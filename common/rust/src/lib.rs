// @file lib.rs
// @brief Core mathematical models for Vinyl-next theme effects (sheen and micro-texture).
//
// SPDX-FileCopyrightText: 2026 Christian Tosta
// SPDX-License-Identifier: GPL-3.0-only

use std::f32;

#[no_mangle]
pub extern "C" fn calculate_vinyl_sheen(dist: f32, intensity: f32, plasticity: f32) -> f32 {
    // The 1px 'Vinylnx Sheen': specular highlight on the physical corner
    if dist < 1.0 {
        return intensity;
    }

    // Non-linear falloff function to simulate dense polycarbonate.
    // We use a negative exponential based on 'plasticity' (coming from vinylnxrc).
    // This avoids banding and creates an organic gradient.
    let falloff = (-plasticity * (dist - 1.0)).exp();

    (intensity * falloff).max(0.0)
}

#[no_mangle]
pub extern "C" fn generate_micro_texture(x: i32, y: i32, seed: u32) -> f32 {
    // Ultra-light grain generator to break banding in 80% transparencies.
    // Simple hash implementation for speed (avoids loading random crates).
    let h = (x as u32).wrapping_mul(1597334677) ^ (y as u32).wrapping_mul(38125417) ^ seed;
    let res = (h.wrapping_mul(h ^ (h >> 16))) as f32;

    // Returns a tiny brightness offset between -0.01 and 0.01
    (res % 200.0) / 10000.0 - 0.01
}
