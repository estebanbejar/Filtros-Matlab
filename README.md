# Interactive Analog & Digital Filter Designer (Butterworth & Chebyshev)

This repository contains a small MATLAB toolbox for teaching and exploring classic analog filter design (Butterworth and Chebyshev type I/II) and its relationship to digital IIR implementation.

The main entry point is the script:

- `selector_filtro.m`

which opens a simple GUI to choose the filter family and then launches the corresponding interactive configurator:

- `filtro_butterworth_interactivo.m`
- `filtro_chebyshev_interactivo.m`

The tools are intended for teaching use (undergraduate courses in Electronics / Signal Processing), but can also be used as a quick design and visualization aid.

---

## Features

- Interactive selection of:
  - Filter family: Butterworth, Chebyshev type I, Chebyshev type II
  - Response type: low-pass, high-pass, band-pass, band-stop
  - Filter order
  - Cutoff / band edge frequencies (Hz)
  - Sampling frequency (Hz)
  - Ripple / attenuation (Chebyshev)

- For each configuration, the tool displays:
  - Digital frequency response: magnitude (dB) and phase (degrees)
  - **Analog low-pass prototype** pole–zero diagram (in the s-plane)
  - **Analog transformed filter** pole–zero diagram (after LP→LP/HP/BP/BS transformation)
  - Analytical analog transfer function \( H(s) \) in LaTeX form
  - Digital IIR coefficients (vectors `b` and `a`)

- One-click PNG export of the full result window (plots + text).

---

## Quick start

1. Clone or download this repository.
2. Open MATLAB and add the repository folder to the path:

   ```matlab
   addpath('path/to/repo');
