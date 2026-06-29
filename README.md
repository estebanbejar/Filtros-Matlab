# Interactive Analog & Digital Filter Designer (Butterworth & Chebyshev)

This repository contains a small MATLAB toolbox for teaching and exploring classic analog filter design and its relationship with digital IIR implementation.

The main entry point is:

- `selector_filtro.m`

which opens a simple GUI and launches one of the following tools:

- `filtro_butterworth_interactivo.m`
- `filtro_chebyshev_interactivo.m`

The tools are intended for teaching use in Electronics, Instrumentation and Signal Processing courses.

---

## Features

The GUI allows interactive selection of:

- Filter family: Butterworth, Chebyshev type I, Chebyshev type II.
- Response type: low-pass, high-pass, band-pass, band-stop.
- Filter order.
- Cutoff or band-edge frequencies in Hz.
- Sampling frequency in Hz.
- Ripple / attenuation in dB for Chebyshev filters.

For each configuration, the result window displays:

- Digital frequency response: magnitude in dB and phase in degrees.
- Pole-zero diagram of the analog low-pass normalized prototype in the s-plane.
- Pole-zero diagram of the transformed analog filter in the s-plane.
- Transfer function of the normalized prototype: \(H_P(s)\).
- Transfer function of the transformed analog filter: \(H_A(s)\).
- Transfer function of the digital IIR filter: \(H_D(z)\).
- Export of the full window as PNG.
- Export of transfer functions as Markdown (`.md`) and LaTeX text (`.txt`).

---

## Quick start

1. Clone or download this repository.
2. Open MATLAB.
3. Add the repository folder to the MATLAB path:

   ```matlab
   addpath('path/to/repo')
   ```

4. Run:

   ```matlab
   selector_filtro
   ```

---

## Design workflow

The tool is based on the classical analog prototype method:

```text
Normalized analog prototype
          |
          v
Frequency transformation in the s-plane
          |
          v
Transformed analog filter H_A(s)
          |
          v
Bilinear transformation
          |
          v
Digital IIR filter H_D(z)
```

This makes it possible to compare, in the same window, the normalized analog prototype, the transformed analog filter and the final digital implementation.

---

## Main transfer functions

The result window shows three transfer functions:

- \(H_P(s)\): normalized analog low-pass prototype.
- \(H_A(s)\): analog filter after the frequency transformation.
- \(H_D(z)\): digital IIR filter obtained after discretization.

The digital transfer function is shown using powers of \(z^{-1}\):

\[
H_D(z)=\frac{b_0+b_1z^{-1}+\cdots+b_Mz^{-M}}
{1+a_1z^{-1}+\cdots+a_Nz^{-N}}
\]

---

## Frequency transformations

The normalized prototype is transformed into a concrete analog filter using the following substitutions:

| Transformation | Substitution |
|---|---|
| Prototype → Low-pass | \(\displaystyle s \rightarrow \frac{s}{\omega_c}\) |
| Prototype → High-pass | \(\displaystyle s \rightarrow \frac{\omega_c}{s}\) |
| Prototype → Band-pass | \(\displaystyle s \rightarrow \frac{s^2+\omega_0^2}{B s}\) |
| Prototype → Band-stop | \(\displaystyle s \rightarrow \frac{B s}{s^2+\omega_0^2}\) |
| Analog → Digital | \(\displaystyle s \rightarrow \frac{2}{T}\frac{1-z^{-1}}{1+z^{-1}}\) |

where:

\[
\omega_c = 2\pi f_c
\]

\[
\omega_l = 2\pi f_l, \qquad \omega_h = 2\pi f_h
\]

\[
\omega_0 = \sqrt{\omega_l\omega_h}
\]

\[
B = \omega_h - \omega_l
\]

and:

\[
T=\frac{1}{f_s}
\]

---

## Example: second-order normalized prototype

For a second-order Butterworth prototype:

\[
H_P(s)=\frac{1}{s^2+\sqrt{2}s+1}
\]

The corresponding transformations lead to:

| Filter | Transfer function |
|---|---|
| Low-pass | \(\displaystyle H_{LP}(s)=\frac{\omega_c^2}{s^2+\sqrt{2}\omega_c s+\omega_c^2}\) |
| High-pass | \(\displaystyle H_{HP}(s)=\frac{s^2}{s^2+\sqrt{2}\omega_c s+\omega_c^2}\) |
| Band-pass | \(\displaystyle H_{BP}(s)=\frac{B^2s^2}{(s^2+\omega_0^2)^2+\sqrt{2}Bs(s^2+\omega_0^2)+B^2s^2}\) |
| Band-stop | \(\displaystyle H_{BS}(s)=\frac{(s^2+\omega_0^2)^2}{(s^2+\omega_0^2)^2+\sqrt{2}Bs(s^2+\omega_0^2)+B^2s^2}\) |

---

## Additional documentation

See also:

- `docs/transformaciones_prototipo.md`
- `docs/funciones_transferencia.md`
- `docs/funciones_transferencia_latex.txt`

