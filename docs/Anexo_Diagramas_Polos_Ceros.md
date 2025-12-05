# Anexo: Interpretación de los diagramas de polos y ceros

Este anexo explica el significado de los dos diagramas de polos y ceros que aparecen en las herramientas de diseño de filtros del repositorio. Su objetivo es clarificar la relación entre el **prototipo analógico** y el **filtro analógico transformado**, tal como se estudia en los textos clásicos de diseño de filtros (por ejemplo, Sedra & Smith o Van Valkenburg).

---

## 1. Primer diagrama: Polos y ceros del prototipo analógico de bajo paso

El primer diagrama corresponde al *prototipo normalizado* de bajo paso (LP) con:

- Frecuencia de corte \( \, \Omega_c = 1 \, \text{rad/s} \, \).
- Polos situados según la familia del filtro:
  - **Butterworth:** polos distribuidos uniformemente sobre un semicírculo en el semiplano izquierdo.
  - **Chebyshev Tipo I:** polos desplazados hacia el eje imaginario para obtener una transición más abrupta.
  - **Chebyshev Tipo II:** polos + ceros finitos en el eje imaginario que producen una fuerte atenuación en la banda de rechazo.

Este diagrama muestra **la estructura matemática fundamental** del filtro antes de aplicar cualquier transformación de frecuencia. Es el mismo que aparece en los libros cuando se presentan las familias de filtros.

**Interpretación didáctica:**

- Permite ver *cómo es* la aproximación que define la familia del filtro.
- No depende de las frecuencias reales del diseño.
- Refleja la suavidad u ondulación de la respuesta en banda pasante.
- Es el punto de partida para cualquier otro tipo de filtro.

---

## 2. Segundo diagrama: Polos y ceros del filtro analógico transformado

El segundo diagrama corresponde al filtro que se obtiene tras aplicar la transformación de frecuencia adecuada:

- LP → LP  
- LP → HP  
- LP → BP  
- LP → BS  

Estas transformaciones sustituyen la variable \( s \) del prototipo por una expresión que cambia la banda de frecuencias en la que el filtro actúa.

**Transformaciones típicas:**

- LP → HP:
  $$ s \longleftarrow rac{\Omega_c^2}{s} $$
- LP → BP:
  $$ s \longleftarrow rac{s^2 + \Omega_0^2}{B s} $$
- LP → BS:
  $$ s \longleftarrow rac{B s}{s^2 + \Omega_0^2} $$

**Interpretación didáctica:**

- Muestra el filtro *real* que corresponde a la especificación introducida por el usuario.
- Explica por qué cambian las posiciones de polos y ceros:
  - En pasa banda, cada polo del prototipo se convierte en *dos polos* → figura más extendida.
  - En rechaza banda, aparecen ceros complejos → zona de fuerte atenuación.
  - En pasa altos, algunos ceros aparecen en el origen.
- Permite comparar visualmente con los diagramas típicos de Sedra & Smith.

---

## 3. Relación entre ambos diagramas

| Diagrama | Qué representa | Para qué sirve |
|---------|----------------|----------------|
| **Prototipo LP (Ωc = 1)** | La familia del filtro (Butterworth o Chebyshev) | Comprender la estructura matemática base |
| **Transformado (LP/HP/BP/BS)** | El filtro real diseñado | Analizar el comportamiento según la aplicación |

Ambos diagramas son necesarios para conectar:

1. **La teoría general** del diseño de filtros analógicos.
2. **El caso particular** del diseño solicitado por el usuario.

---

## 4. ¿Por qué no se muestra el diagrama del filtro digital?

Aunque MATLAB produce finalmente un filtro digital IIR mediante la transformada bilineal, los polos y ceros del filtro digital:

- ya no tienen una distribución directamente interpretable,
- están afectados por la distorsión en frecuencia propia de la bilineal,
- no aparecen en los libros clásicos para el análisis conceptual.

Por eso la herramienta muestra solo las dos fases analógicas, que son las relevantes desde el punto de vista académico.

---

## 5. Conclusión

Los dos diagramas cumplen funciones distintas:

- El **prototipo LP** permite entender la *naturaleza* del filtro.
- El **filtro transformado** permite entender su *comportamiento* en la banda deseada.

Incluir ambos es pedagógicamente esencial y permite que los estudiantes visualicen la conexión entre teoría, transformaciones de frecuencia y diseño práctico.
