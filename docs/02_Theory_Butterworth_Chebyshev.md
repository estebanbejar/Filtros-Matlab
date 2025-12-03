# Theory – Butterworth and Chebyshev Filters

This document summarises the theoretical background of the filters implemented in this project.

## 1. Introduction

Classical IIR filters are derived from analog low-pass prototypes, then transformed and converted to digital form via the bilinear transform.

## 2. Butterworth Filters

Butterworth filters provide a maximally flat magnitude response.

### 2.1 Magnitude

|H(jω)| = 1 / sqrt(1 + (ω/ωc)^(2N))

### 2.2 Poles

Poles are equally spaced on a circle in the left half-plane:

θ_k = π/2 + (2k−1)π/(2N)

## 3. Chebyshev Filters

Chebyshev filters offer a sharper transition.

### 3.1 Type I

- Ripple in passband
- No finite zeros
- Based on Chebyshev polynomials

### 3.2 Type II

- Flat passband
- Ripple in stopband
- Contains finite-imaginary-axis zeros

## 4. Frequency Transformations

The analog low-pass prototype can be converted to:
- High-pass: s → ωc² / s
- Band-pass: s → (s² + ω₀²)/(B s)
- Band-stop: s → (B s)/(s² + ω₀²)

These transformations produce the second pole-zero diagram in the interface.

## 5. Analog → Digital

MATLAB applies the bilinear transform:

s = (2/T) * (1 − z⁻¹) / (1 + z⁻¹)

## 6. References

1. Sedra & Smith – Microelectronic Circuits, Chapter 14.
2. Van Valkenburg – Analog Filter Design.
3. Oppenheim & Schafer – Discrete-Time Signal Processing.
4. Proakis & Manolakis – Digital Signal Processing.
5. MATLAB Signal Processing Toolbox documentation.
