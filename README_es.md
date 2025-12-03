# Diseñador interactivo de filtros analógicos y digitales (Butterworth y Chebyshev)

Este repositorio contiene un pequeño conjunto de herramientas en MATLAB para **diseñar y explorar filtros clásicos** de tipo Butterworth y Chebyshev (tipos I y II), partiendo de prototipos analógicos y obteniendo finalmente filtros digitales IIR.

El punto de entrada principal es:

- `selector_filtro.m`

que abre una ventana de selección y, a partir de ahí, lanza el configurador correspondiente:

- `filtro_butterworth_interactivo.m`
- `filtro_chebyshev_interactivo.m`

Las herramientas están pensadas para uso **docente** (asignaturas de Electrónica / Procesado Digital de Señal), pero cualquier persona familiarizada con MATLAB puede utilizarlas como ayuda rápida para el diseño de filtros.

---

## Características principales

- Selección interactiva de:
  - Familia de filtro: Butterworth, Chebyshev Tipo I, Chebyshev Tipo II
  - Tipo de respuesta: pasa bajos, pasa altos, pasa banda, elimina banda
  - Orden del filtro
  - Frecuencias de corte o de banda (en Hz)
  - Frecuencia de muestreo (en Hz)
  - Ondulación / atenuación en dB (según el tipo de Chebyshev)

- Para cada configuración se muestra:
  - Respuesta en frecuencia del filtro digital: magnitud (dB) y fase (grados)
  - Diagrama de polos y ceros del **prototipo analógico de bajo paso**
  - Diagrama de polos y ceros del **filtro analógico transformado** (LP→LP, LP→HP, LP→BP, LP→BS)
  - Expresión simbólica de la función de transferencia analógica \(H(s)\) en notación LaTeX
  - Coeficientes del filtro digital (vectores `b` y `a`)

- Exportación con un solo clic:
  - Botón **“Guardar PNG”** que genera una imagen con **toda la ventana**, incluyendo gráficos, texto y ecuaciones.

---

## Puesta en marcha rápida

1. Clonar o descargar este repositorio.
2. Abrir MATLAB y añadir la carpeta del repositorio al path:

   ```matlab
   addpath('ruta/a/este/repositorio');
   ```

3. Ejecutar el selector:

   ```matlab
   selector_filtro
   ```

4. En la ventana de selección:
   - Elegir la familia de filtro (Butterworth, Chebyshev Tipo I o Tipo II).
   - Pulsar **“Configurar Filtro”**.

5. En la ventana de configuración:
   - Seleccionar el tipo de filtro (pasa bajos, pasa altos, etc.).
   - Introducir el orden, las frecuencias de corte y la frecuencia de muestreo.
   - En filtros Chebyshev, fijar la ondulación (Tipo I) o la atenuación mínima en banda de rechazo (Tipo II).
   - Elegir el modo de visualización:
     - **Ventana Independiente** (ventana propia con todos los resultados).
     - **Herramienta MATLAB (fvtool)**.

6. Pulsar **“Generar Filtro”** para calcularlo y mostrar la ventana de resultados.

7. Utilizar el botón **“Guardar PNG”** para generar una captura de la ventana completa.

---

## Scripts incluidos

- `selector_filtro.m`  
  Ventana inicial. Permite elegir la familia de filtro y abre el configurador correspondiente.

- `filtro_butterworth_interactivo.m`  
  Configurador interactivo de filtros Butterworth. Calcula:
  - Filtro digital con `butter`
  - Prototipo analógico con `buttap`
  - Filtros analógicos transformados con `lp2lp`, `lp2hp`, `lp2bp`, `lp2bs`
  - Respuesta en frecuencia y diagramas de polos y ceros.

- `filtro_chebyshev_interactivo.m`  
  Configurador interactivo de filtros Chebyshev, común a:
  - Chebyshev Tipo I (`cheby1`, `cheb1ap`)
  - Chebyshev Tipo II (`cheby2`, `cheb2ap`)

  Utiliza las mismas transformaciones de frecuencia que el Butterworth.

- Funciones auxiliares:
  - `tf_s_to_latex`, `poly_to_latex_s` (definidas al final de los scripts).  
    Generan cadenas LaTeX para escribir \(H(s)\) a partir de los coeficientes del prototipo analógico.
  - `guardarPNG`  
    Captura toda la ventana (`uifigure`) y la guarda en formato PNG.

---

## Documentación adicional

En la carpeta `/docs` se incluyen versiones más detalladas de la documentación:

- `01_Guia_de_Uso.md` – Guía de uso paso a paso de los tres scripts.
- `02_Fundamentos_Teoricos.md` – Fundamentos teóricos de los filtros Butterworth y Chebyshev, con referencia a Sedra & Smith.
- `03_Actividades_Estudiantes.md` – Propuesta de actividades prácticas para el alumnado.

---

## Licencia y cita

*(Completar este apartado según la licencia elegida — por ejemplo MIT, BSD, etc. — y la forma en que se desea que se cite el material.)*
