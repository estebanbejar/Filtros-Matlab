# Fundamentos teóricos – Filtros Butterworth y Chebyshev

Este documento resume los conceptos teóricos más relevantes para entender el funcionamiento de los scripts de este repositorio:

- Prototipos analógicos de bajo paso.
- Familias Butterworth y Chebyshev (Tipos I y II).
- Transformaciones de frecuencia (LP→LP, LP→HP, LP→BP, LP→BS).
- Relación entre los diagramas de polos y ceros mostrados por la herramienta y las figuras habituales en los libros de texto (por ejemplo, Sedra & Smith).

---

## 1. Introducción

El diseño clásico de filtros IIR parte de **prototipos analógicos de bajo paso**. El proceso típico es:

1. Diseñar un prototipo analógico de bajo paso normalizado, \(H_p(s)\), con:
   - frecuencia de corte $$\Omega_c = 1\,\text{rad/s}$$,
   - especificaciones de ondulación, atenuación, etc.

2. Aplicar una **transformación de frecuencia** para obtener:
   - pasa altos (HP),
   - pasa banda (BP),
   - o rechaza banda (BS).

3. Convertir el filtro analógico resultante a un filtro digital IIR mediante la **transformada bilineal**.

Los scripts de este repositorio se centran en visualizar las etapas (1) y (2).

---

## 2. Filtros Butterworth

### 2.1 Magnitud

Los filtros Butterworth se caracterizan por una respuesta de magnitud **máximamente plana** en la banda pasante. La magnitud al cuadrado de un filtro Butterworth de orden \(N\) viene dada por:

$$
\lvert H(j\omega) \rvert^2
= \frac{1}{1 + \left( \frac{\omega}{\omega_c} \right)^{2N}}
$$

donde \(\omega_c\) es la frecuencia de corte (en rad/s).

### 2.2 Polos en el plano s

Los polos de un prototipo Butterworth normalizado se sitúan sobre un **semicírculo** en el semiplano izquierdo:

$$
s_k = e^{j\theta_k}, \quad
\theta_k = \frac{\pi}{2} + \frac{(2k-1)\pi}{2N},
\quad k = 1,\dots,N
$$

Esto garantiza que:
- todos los polos tienen parte real negativa (estabilidad),
- no existen ceros finitos.

En MATLAB, estos polos se obtienen con:

```matlab
[z_lp, p_lp, k_lp] = buttap(N);
```

donde `p_lp` contiene los polos del prototipo.

---

## 3. Filtros Chebyshev

Existen dos familias principales:

- **Chebyshev Tipo I**: ondulación en banda pasante, stopband monótona.
- **Chebyshev Tipo II**: banda pasante monótona, ondulación en banda de rechazo y ceros finitos.

Ambas familias logran transiciones más rápidas que Butterworth para un mismo orden, a costa de la ondulación.

### 3.1 Chebyshev Tipo I

La magnitud al cuadrado está dada por:

$$
\lvert H(j\omega) \rvert^2
= \frac{1}{1 + \varepsilon^2 \, C_N^2\left(\frac{\omega}{\omega_c}\right)}
$$

donde:
- \(\varepsilon\) está relacionado con la ondulación en banda pasante (\(R_p\) en dB),
- \(C_N(\cdot)\) es el polinomio de Chebyshev de orden \(N\).

En MATLAB, el prototipo analógico se obtiene con:

```matlab
[z_lp, p_lp, k_lp] = cheb1ap(N, Rp);
```

y los polos resultan más cercanos al eje imaginario que en Butterworth, lo que se traduce en una transición más abrupta.

### 3.2 Chebyshev Tipo II

En Chebyshev Tipo II:

- la banda pasante es monótona (sin ondulación),
- la banda de rechazo presenta ondulación,
- aparecen **ceros finitos** en el eje imaginario, que producen atenuaciones muy altas en determinadas frecuencias.

El prototipo analógico se obtiene con:

```matlab
[z_lp, p_lp, k_lp] = cheb2ap(N, Rs);
```

donde \(R_s\) es la atenuación mínima en banda de rechazo (en dB).

Estos ceros son precisamente los que se observan en el diagrama de polos y ceros del prototipo Chebyshev Tipo II.

---

## 4. Transformaciones de frecuencia

El prototipo analógico de bajo paso se transforma en filtros de otro tipo mediante sustituciones en la variable \(s\).

### 4.1 LP → LP (nuevo \(\Omega_c\))

Para cambiar simplemente la frecuencia de corte de \(1\,\text{rad/s}\) a \(\Omega_c\):

$$
s \;\leftarrow\; \frac{s}{\Omega_c}
$$

En MATLAB: `lp2lp`.

### 4.2 LP → HP

Para obtener un pasa altos con frecuencia de corte \(\Omega_c\):

$$
s \;\leftarrow\; \frac{\Omega_c^2}{s}
$$

En MATLAB: `lp2hp`.

### 4.3 LP → BP

Dados dos bordes de banda \(\Omega_1\) y \(\Omega_2\), se define:

$$
\Omega_0 = \sqrt{\Omega_1 \Omega_2}, \qquad
B = \Omega_2 - \Omega_1
$$

y la transformación:

$$
s \;\leftarrow\; \frac{s^2 + \Omega_0^2}{B s}
$$

En MATLAB: `lp2bp`.

Esta transformación duplica los polos (cada polo del prototipo da lugar a dos polos en el filtro pasa banda), y genera distribuciones de polos en el plano \(s\) que recuerdan a las figuras típicas de los libros (por ejemplo, Sedra & Smith).

### 4.4 LP → BS

De forma análoga, para filtros elimina banda:

$$
s \;\leftarrow\; \frac{B s}{s^2 + \Omega_0^2}
$$

En MATLAB: `lp2bs`.

Aquí, además de la duplicación de polos, aparecen ceros complejos conjugados que determinan la zona de fuerte atenuación.

---

## 5. Del prototipo analógico al filtro digital

Una vez obtenido el filtro analógico (tras la transformación de frecuencia adecuada), MATLAB utiliza técnicas estándar para convertirlo en un filtro digital IIR, siendo la más habitual la **transformada bilineal**:

$$
s = \frac{2}{T} \cdot \frac{1 - z^{-1}}{1 + z^{-1}}
$$

donde \(T\) es el periodo de muestreo. Esta transformación:

- preserva la estabilidad (el semiplano izquierdo se mapea dentro del círculo unidad),
- introduce una distorsión en frecuencia (que se corrige mediante prewarping cuando es necesario).

Las funciones de alto nivel:

- `butter`
- `cheby1`
- `cheby2`

se encargan internamente de este proceso a partir de las especificaciones digitales (frecuencias normalizadas respecto a \(f_s\), ondulación/atenuación en dB, etc.).

---

## 6. Relación con las figuras de Sedra & Smith

En el libro de **Sedra, A. S., & Smith, K. C. – *Microelectronic Circuits***, los capítulos dedicados a filtros activos muestran:

1. **Distribuciones de polos** en el plano \(s\) para los prototipos Butterworth y Chebyshev.  
2. **Distribuciones de polos y ceros** para los filtros pasa banda y elimina banda derivados de esos prototipos.

Los dos diagramas de polos y ceros que se muestran en los scripts de este repositorio corresponden exactamente a estas dos etapas:

- El diagrama del **prototipo de bajo paso**.  
- El diagrama del **filtro transformado** (BP, BS, etc.).

Esto permite a las y los estudiantes vincular directamente:
- la teoría vista en clase o en el libro,
- con un ejemplo numérico concreto en MATLAB.

---

## 7. Referencias

- Sedra, A. S., & Smith, K. C. (2015). *Microelectronic Circuits* (7th ed.). Oxford University Press.  
- Van Valkenburg, M. E. (1982). *Analog Filter Design*. Holt, Rinehart and Winston.  
- Oppenheim, A. V., & Schafer, R. W. (2010). *Discrete-Time Signal Processing* (3rd ed.). Pearson.  
- Proakis, J. G., & Manolakis, D. K. (1996). *Digital Signal Processing: Principles, Algorithms, and Applications*. Prentice Hall.  
- Documentación de MATLAB – Signal Processing Toolbox.
