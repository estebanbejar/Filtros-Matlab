# Actividades propuestas para estudiantes

Este documento recoge una serie de actividades y ejercicios que pueden realizarse con los scripts:

- `selector_filtro.m`
- `filtro_butterworth_interactivo.m`
- `filtro_chebyshev_interactivo.m`

El objetivo es reforzar los conceptos de diseño de filtros analógicos y digitales, y la interpretación de polos, ceros y respuestas en frecuencia.

---

## Actividad 1 – Diseño básico de un Butterworth

1. Ejecuta `selector_filtro` y elige **Butterworth**.
2. Diseña un filtro pasa bajos de **4.º orden** con:
   - Frecuencia de muestreo: \(f_s = 8\,\text{kHz}\).
   - Frecuencia de corte: \(f_c = 1\,\text{kHz}\).
3. Genera la ventana de resultados y guarda el PNG correspondiente.
4. Responde:
   - ¿Cuántos polos tiene el prototipo de bajo paso?  
   - ¿Dónde se sitúan en el plano \(s\) (cuadrantes, simetrías)?  
   - ¿Se observa una banda pasante “suave” sin ondulaciones?  

---

## Actividad 2 – Comparación de familias de filtros

1. Diseña tres filtros pasa bajos de 4.º orden, \(f_s = 8\,\text{kHz}\) y \(f_c = 1\,\text{kHz}\):
   - Butterworth.  
   - Chebyshev Tipo I, ondulación en banda pasante \(R_p = 1\,\text{dB}\).  
   - Chebyshev Tipo II, atenuación mínima en banda de rechazo \(R_s = 40\,\text{dB}\).
2. Guarda un PNG de cada uno.
3. Compara:
   - Las respuestas en magnitud: ¿qué familia tiene la transición más rápida?  
   - La presencia o ausencia de ondulación en banda pasante y de rechazo.  
   - Los diagramas de polos y ceros de los prototipos.
4. Elabora un breve comentario (5–10 líneas) justificando qué filtro utilizarías, por ejemplo, en una aplicación de audio.

---

## Actividad 3 – Transformación pasa banda y Sedra & Smith

1. Diseña un prototipo Chebyshev Tipo II de 4.º orden.  
2. Configura un filtro **pasa banda** con:
   - \(f_1 = 500\,\text{Hz}\),
   - \(f_2 = 1500\,\text{Hz}\),
   - \(f_s = 8\,\text{kHz}\).
3. Observa la diferencia entre:
   - el diagrama de polos/ceros del prototipo de bajo paso;
   - el diagrama del filtro pasa banda.
4. Consulta en el libro de Sedra & Smith la figura correspondiente a un filtro Chebyshev pasa banda (capítulo de filtros activos) y contesta:
   - ¿Cómo se relacionan los polos del prototipo con los del filtro pasa banda?  
   - ¿Por qué la parte imaginaria de muchos polos es ahora mucho mayor?  
   - ¿Por qué no es aconsejable forzar una escala “1:1” en los ejes del plano \(s\) en estos casos?

---

## Actividad 4 – Del diseño a la implementación digital

1. Diseña un filtro Butterworth pasa bajos de 6.º orden con:
   - \(f_s = 10\,\text{kHz}\)
   - \(f_c = 2\,\text{kHz}\)
2. Copia los coeficientes `b` y `a` desde la ventana de resultados a un script nuevo de MATLAB.
3. Genera una señal de prueba formada por la suma de dos senos:
   - uno a \(1\,\text{kHz}\),
   - otro a \(3\,\text{kHz}\).
4. Filtra la señal y representa:
   - la señal original y la filtrada en el dominio temporal,
   - el espectro (por ejemplo mediante `fft`).
5. Comenta:
   - qué componente ha sido atenuada,
   - si la pendiente de la transición es suficiente para esta aplicación.

---

## Actividad 5 – Efecto del orden del filtro

1. Para cada familia (Butterworth y Chebyshev Tipo I), diseña filtros pasa bajos de orden:
   - 2,
   - 4,
   - 8.
2. Mantén la misma frecuencia de corte y de muestreo en todos los casos.
3. Compara:
   - la anchura de la zona de transición,  
   - la ondulación (si la hay),  
   - la distribución de polos en el plano \(s\).
4. Discute:
   - ventajas e inconvenientes de aumentar el orden,  
   - posibles problemas numéricos o de sensibilidad a coeficientes.

---

## Actividad 6 – Uso de los filtros en un caso práctico

(Actividad abierta para trabajos o prácticas de laboratorio)

1. Elige una señal real o simulada relacionada con tu campo de interés (audio, sensores, comunicaciones, etc.).
2. Define unas especificaciones de filtrado razonables (por ejemplo, ancho de banda de interés, ruidos a eliminar, etc.).
3. Utiliza los scripts para:
   - seleccionar una familia de filtro,
   - ajustar el orden y las frecuencias de corte,
   - obtener los coeficientes `b` y `a`.
4. Implementa el filtrado en MATLAB y presenta:
   - señales de entrada y salida,
   - alguna métrica básica (por ejemplo, relación señal/ruido antes y después).
5. Justifica la elección de la familia de filtro y del orden.

