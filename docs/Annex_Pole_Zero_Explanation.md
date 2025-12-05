# Annex: Interpretation of Pole–Zero Diagrams

This annex explains the meaning of the two pole–zero diagrams displayed by the filter design tools in this repository. Its purpose is to clarify the relationship between the **analog low-pass prototype** and the **frequency-transformed analog filter**, as traditionally presented in textbooks such as *Sedra & Smith* and *Van Valkenburg*.

---

## 1. First diagram: Poles and zeros of the normalized low-pass prototype

The first diagram corresponds to the **normalized low-pass prototype**, defined with:

- Cutoff frequency  $\Omega_c = 1 {rad/s}$
- Pole locations determined by the filter family:
  - **Butterworth:** poles uniformly distributed on a semicircle in the left-half plane.
  - **Chebyshev Type I:** poles shifted toward the imaginary axis for a steeper transition band.
  - **Chebyshev Type II:** poles and finite zeros on the imaginary axis, producing deep attenuation in the stopband.

This diagram represents the **fundamental mathematical structure** of the filter *before* any frequency transformation is applied. It is the same diagram found in classical filter design textbooks.

### Didactic interpretation

The prototype diagram allows students to:

- Understand the *intrinsic behaviour* of each filter family.
- Observe smoothness or ripple in the passband.
- See symmetric pole patterns independent of real-world cutoff frequencies.
- Identify the base structure from which all filter types (HP, BP, BS) derive.

---

## 2. Second diagram: Poles and zeros of the frequency-transformed analog filter

The second diagram corresponds to the filter obtained after applying the relevant **frequency transformation**:

- Low-pass → Low-pass  
- Low-pass → High-pass  
- Low-pass → Band-pass  
- Low-pass → Band-stop  

These transformations replace the variable \( s \) by an expression that reshapes the frequency response according to the target specification.

### Typical transformations

- **LP → HP**     $s \longleftarrow \frac{\Omega_c^2}{s}$

- **LP → BP**     $s \longleftarrow \frac{s^2 + \Omega_0^2}{B s}$

- **LP → BS**     $s \longleftarrow \frac{B s}{s^2 + \Omega_0^2}$

### Didactic interpretation

This diagram represents the **actual analog filter** whose specifications the user has entered.

Key observations:

- In **band-pass** transformation, each pole of the prototype generates **two poles**, producing an elongated pattern in the \( s \)-plane.
- In **band-stop** filters, complex-conjugate zeros appear, defining the stopband attenuation.
- In **high-pass** filters, zeros often appear at the origin.
- This diagram closely matches those found in *Sedra & Smith* when studying band-pass and band-stop realizations.

---

## 3. Relationship between the two diagrams

| Diagram | What it represents | Purpose |
|---------|--------------------|---------|
| **LP prototype (Ωc = 1)** | Fundamental behaviour of Butterworth or Chebyshev families | Understanding the mathematical basis |
| **Transformed analog filter** | The real filter for the chosen specification | Analysing practical operation and behaviour |

The combination of both diagrams helps students connect:

1. **General theory**,  
2. **Specific design steps**,  
3. **Visual interpretation** of poles and zeros.

---

## 4. Why the digital pole–zero diagram is NOT shown

The final digital filter is obtained via the bilinear transform, but its pole–zero pattern:

- is distorted by frequency warping,
- does not preserve the analog geometric structure,
- is rarely used in textbooks for conceptual understanding,
- provides less intuitive insight for teaching purposes.

Therefore, the tool displays only the **analog** diagrams, which are the ones that best support learning.

---

## 5. Conclusion

The two diagrams serve complementary roles:

- The **low-pass prototype** reveals the *nature* of the approximation.
- The **frequency-transformed analog filter** reveals the *behaviour* of the filter within the target frequency band.

Showing both diagrams helps students understand the connection between theory, frequency transformations, and practical filter design.

