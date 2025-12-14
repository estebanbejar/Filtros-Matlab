# Transformación del prototipo pasa-bajo normalizado al filtro pasa-banda real

El diseño clásico de filtros analógicos (Butterworth, Chebyshev, etc.) se basa siempre en un **prototipo pasa-bajo (LP)** normalizado. Este prototipo tiene:

- Frecuencia de corte normalizada:  $\omega_c = 1 \;\text{rad/s}$
- Polos dispuestos de forma canónica y simétrica.
- Una función de transferencia universal para cada orden y tipo de filtro.

La transformación a otros tipos de filtro (HP, BP, BS) **no cambia los polos del prototipo**, sino que los **mapea** mediante sustituciones matemáticas en la variable compleja \(s\).

---

## 1. Prototipo pasa-bajo (LP) normalizado

Para un filtro de orden \(N\), MATLAB genera un prototipo:

$$H_{LP}(s) = \frac{1}{a_0 s^N + a_1 s^{N-1} + \cdots + a_N}$$

Este prototipo es **independiente de la frecuencia real** del filtro final.  
Es decir, dos filtros distintos del mismo orden tienen el mismo prototipo LP.

---

## 2. Transformación LP → BP (i)

Para obtener un **pasa-banda analógico**, se sustituye:

$$s \;\longleftarrow\; \frac{s^2 + \omega_0^2}{B\,s}$$

donde:

- Frecuencia inferior: $\omega_1 = 2\pi f_1$
- Frecuencia superior: $\omega_2 = 2\pi f_2$
- Ancho de banda:      $B = \omega_2 - \omega_1$
- Frecuencia central geométrica: $\omega_0 = \sqrt{\omega_1 \omega_2}$

## 3. Transformación LP → BP (ii)
Esta sustitución produce:

### ✔ Duplicación del orden del filtro  
Un LP de orden \(N\) produce un BP de orden \(2N\).

### ✔ Desplazamiento de polos alrededor de ±ω₀  
Los polos del prototipo se distribuyen ahora alrededor de la frecuencia central geométrica.

### ✔ Apertura horizontal proporcional al ancho de banda  
- Bandas estrechas → polos más verticales.  
- Bandas anchas → polos más abiertos horizontalmente.

---

## 4. Interpretación del plano-s

- **Eje horizontal (σ):** parte real de $s = \sigma + j\omega$. Controla estabilidad y amortiguamiento.
- **Eje vertical (jω):** parte imaginaria. Representa frecuencia.

Después de LP→BP:

- Los polos se sitúan en torno a \(\pm j\omega_0\).  
- Se mantiene la simetría respecto a ambos ejes.  
- Aparecen pares de polos complejos conjugados.

---

## 5. Prototipo vs filtro real: por qué no coinciden

La forma normalizada:

$$
H_{LP}(s) = \frac{1}{s^N + a_1 s^{N-1} + \cdots + 1}
$$

**no incorpora ninguna frecuencia concreta**.  
Pero el filtro real sí, mediante:

$$
H_{BP}(s) = H_{LP}\!\left( \frac{s^2 + \omega_0^2}{B s} \right)
$$
Por eso:

- La H(s) del prototipo es siempre la misma para un orden N.  
- La H(s) real cambia sus coeficientes según $(f_1, f_2)$.  
- El orden final aumenta de \(N\) → \(2N\).

---

## 6. Resumen conceptual

| Etapa | Representa | Cambia | No cambia |
|------|------------|--------|-----------|
| Prototipo LP | Modelo normalizado | Nada | Orden, estructura |
| Transformación LP→BP | Mapeo matemático | Polos, ceros, orden | Prototipo base |
| Filtro BP real | Implementación | Coeficientes reales | Tipo de prototipo |


