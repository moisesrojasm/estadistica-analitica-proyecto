# Proyecto de Estadística Analítica en R  
Análisis completo de datos agrupados: frecuencias, tendencia central, dispersión, momentos, sesgo, curtosis y gráficas estadísticas.

Este proyecto procesa un archivo con datos numéricos no agrupados, construye la tabla de frecuencias agrupadas y genera todas las medidas estadísticas importantes.  
Además, produce las gráficas principales: **histograma**, **ojiva** y **polígono de frecuencias suavizado**.

Todas las tablas se guardan automáticamente en la carpeta **Resultados/Data.frames** en formato `.csv`.

---

## Estructura del proyecto

```plaintext
estadistica-analitica-proyecto/
│
├── Data/
│   └── datos_equipo_5.txt
│
├── Funciones/
│   ├── disFrecuencias.R          # Tabla de distribución de frecuencias
│   ├── tenCentral.R              # Medidas de tendencia central
│   ├── dispersión.R              # Dispersión + momentos + sesgo + curtosis
│   └── gráficas.R                # Histograma, ojiva y polígono suavizado
│
├── Resultados/
│   ├── Data.frames/
│   │   ├── Tabla_frecuencias.csv
│   │   ├── Tabla_tendencia_central.csv
│   │   ├── Tabla_dispersion.csv
│   │   ├── Tabla_momentos.csv
│   │   └── Tabla_sesgo_y_curtosis.csv
│   │
│   └── Graficas/
│       ├── Histograma_datos_equipo_5.pdf
│       ├── Ojiva_datos_equipo_5.pdf
│       └── PoligonoFrecuencias_datos_equipo_5.pdf
│
└── main.R
```

---

## Descripción de cada módulo

### **1. disFrecuencias.R**

Construye la **tabla de distribución de frecuencias agrupadas**, usando la **regla de Sturges** para determinar el número de clases.

- **Número de clases (Sturges)**  
  $$k = 1 + \log_2(N)$$  

- **Rango de los datos**  
  $$R = L_{\max} - L_{\min}$$  

- **Amplitud de clase aproximada**  
  $$A \approx \frac{R}{k}$$  

- **Intervalos de clase**  
  Intervalos de la forma $[L_i, U_i]$ con:  
  $$A_i = U_i - L_i$$  

- **Marca de clase**  
  $$m_i = \frac{L_i + U_i}{2}$$  

- **Frecuencia absoluta de la clase**  
  $$f_i = \text{número de datos en la clase } i$$  

- **Frecuencia acumulada**  
  $$F_i = \sum_{j=1}^{i} f_j$$  

- **Frecuencia relativa**  
  $$h_i = \frac{f_i}{N}$$  

- **Frecuencia relativa acumulada**  
  $$H_i = \sum_{j=1}^{i} h_j$$  

La tabla se guarda en:  
`Resultados/Data.frames/Tabla_frecuencias.csv`

---

### **2. tenCentral.R**

Calcula las principales **medidas de tendencia central** para datos agrupados.  
Sea $m_i$ la marca de clase, $f_i$ la frecuencia de la clase $i$ y $N = \sum f_i$.

- **Media aritmética agrupada**  
  $$\bar{x} = \frac{\sum f_i m_i}{N}$$  

- **Media armónica agrupada**  
  $$H = \frac{N}{\sum \frac{f_i}{m_i}}$$  

- **Media geométrica agrupada**  
  $$G = \exp\left( \frac{\sum f_i \ln(m_i)}{N} \right)$$  

- **Media cuadrática (RMS) agrupada**  
  $$\text{RMS} = \sqrt{ \frac{\sum f_i m_i^2}{N} }$$  

- **Mediana agrupada** (cuantil con $p = 0.5$)  
  Si la mediana cae en la clase $i$:  
  $$Me = L_i + A_i \left( \frac{\frac{N}{2} - F_{i-1}}{f_i} \right)$$  

- **Moda agrupada** (clase modal)  
  Sea $f_m$ la frecuencia de la clase modal, $f_{m-1}$ la anterior y $f_{m+1}$ la posterior:  
  $$Mo = L_m + A_m \left( \frac{f_m - f_{m-1}}{(f_m - f_{m-1}) + (f_m - f_{m+1})} \right)$$  

La tabla se guarda en:  
`Resultados/Data.frames/Tabla_tendencia_central.csv`

---

### **3. dispersión.R**

Este módulo realiza tres análisis completos usando la tabla de frecuencias.

---

#### **A. Medidas de dispersión**

Primero se calculan los cuantiles agrupados usando la fórmula general del cuantil para proporción $p$.  
Si el cuantil cae en la clase $i$:

$$
Q_p = L_i + A_i \left( \frac{pN - F_{i-1}}{f_i} \right)
$$

A partir de ahí se obtienen:

- **Cuartiles $Q_1$ y $Q_3$**  
  $$Q_1 = Q_{0.25}, \quad Q_3 = Q_{0.75}$$  

- **Percentiles $P_{10}$ y $P_{90}$**  
  $$P_{10} = Q_{0.10}, \quad P_{90} = Q_{0.90}$$  

- **Rango semi intercuartílico (RSI)**  
  $$\text{RSI} = \frac{Q_3 - Q_1}{2}$$  

- **Rango semi percentílico (RSP)**  
  $$\text{RSP} = \frac{P_{90} - P_{10}}{2}$$  

- **Desviación media respecto a la media**  
  $$DM_{\mu} = \frac{1}{N} \sum f_i \, |m_i - \bar{x}|$$  

- **Desviación media respecto a la mediana**  
  $$DM_{Me} = \frac{1}{N} \sum f_i \, |m_i - Me|$$  

- **Varianza poblacional agrupada**  
  $$\sigma^2 = \frac{1}{N} \sum f_i (m_i - \bar{x})^2$$  

- **Desviación estándar poblacional**  
  $$\sigma = \sqrt{\sigma^2}$$  

- **Coeficiente de variación (CV)**  
  $$CV = \frac{\sigma}{\bar{x}}$$  

- **Coeficiente cuartílico de dispersión (Bowley)**  
  $$C_B = \frac{Q_3 - Q_1}{Q_3 + Q_1}$$  

La tabla se guarda en:  
`Resultados/Data.frames/Tabla_dispersion.csv`

---

#### **B. Momentos estadísticos**

Sea $m_i$ la marca de clase, $\bar{x}$ la media, $Me$ la mediana y $Mo$ la moda.

- **Momentos al origen** (respecto a 0):  
  $$m_k = \frac{1}{N} \sum f_i m_i^k, \quad k = 1,2,3,4$$  

- **Momentos centrales respecto a la media**:  
  $$\mu_k = \frac{1}{N} \sum f_i (m_i - \bar{x})^k, \quad k = 1,2,3,4$$  
  En particular:  
  $$\mu_1 = 0, \quad \mu_2 = \sigma^2$$  

- **Momentos respecto a la mediana**:  
  $$m^{(Me)}_k = \frac{1}{N} \sum f_i (m_i - Me)^k, \quad k = 1,2,3,4$$  

- **Momentos respecto a la moda**:  
  $$m^{(Mo)}_k = \frac{1}{N} \sum f_i (m_i - Mo)^k, \quad k = 1,2,3,4$$  

- **Momentos adimensionales (centrales, estandarizados)**:  
  $$a_k = \frac{\mu_k}{\sigma^k}, \quad k = 1,2,3,4$$  

- **Momentos adimensionales respecto a la moda**:  
  $$a_k^{(Mo)} = \frac{m^{(Mo)}_k}{\sigma^k}, \quad k = 1,2,3,4$$  

La tabla se guarda en:  
`Resultados/Data.frames/Tabla_momentos.csv`

---

#### **C. Medidas de forma: sesgo y curtosis**

Con base en los momentos y cuantiles calculados:

- **Sesgo de Pearson 1**  
  $$\text{Sesgo}_{P1} = \frac{\bar{x} - Mo}{\sigma}$$  

- **Sesgo de Pearson 2**  
  $$\text{Sesgo}_{P2} = 3 \cdot \frac{\bar{x} - Me}{\sigma}$$  

- **Sesgo cuartílico de Bowley**  
  $$\text{Sesgo}_{B} = \frac{Q_3 + Q_1 - 2Me}{Q_3 - Q_1}$$  

- **Sesgo de Kelly (percentiles 10 y 90)**  
  $$\text{Sesgo}_{K} = \frac{P_{90} + P_{10} - 2Me}{P_{90} - P_{10}}$$  

- **Curtosis de Fisher**  
  $$\beta_2 = \frac{\mu_4}{\sigma^4}$$  

- **Exceso de curtosis**  
  $$\gamma_2 = \beta_2 - 3$$  

- **Curtosis de Moors**  
  $$\text{Curtosis}_{M} = \frac{Q_3 - Q_1}{P_{90} - P_{10}}$$  

La tabla se guarda en:  
`Resultados/Data.frames/Tabla_sesgo_y_curtosis.csv`

---

### **4. gráficas.R**

Este módulo genera las gráficas principales del análisis.  
Todas se basan en la tabla de frecuencias agrupadas.

- **Histograma de frecuencias**  
  Representa las frecuencias absolutas $f_i$ por intervalo:  
  - Eje x: intervalos de clase $[L_i, U_i]$  
  - Eje y: frecuencia absoluta $f_i$  

- **Ojiva (frecuencia relativa acumulada)**  
  Representa la frecuencia relativa acumulada $H_i$:  
  - Eje x: intervalos de clase  
  - Eje y: frecuencia relativa acumulada  
  $$H_i = \sum_{j=1}^{i} \frac{f_j}{N}$$  

- **Polígono de frecuencias suavizado con LOESS**  
  Se trazan puntos $(m_i, f_i)$ y se ajusta una curva suavizada:  
  - Eje x: marca de clase $m_i$  
  - Eje y: frecuencia absoluta $f_i$  
  - Suavizado: método local LOESS (implementado en `geom_smooth(method = "loess")`)  

Además, en el subtítulo del polígono se muestra la interpretación cualitativa del sesgo y la curtosis usando los valores calculados en `dispersión.R`.

Todas las gráficas se exportan en PDF dentro de:  
`Resultados/Graficas/`

---

## Ejecución del proyecto

Todo se ejecuta desde `main.R`.

Flujo general:

1. Limpia el entorno.  
2. Carga los módulos del proyecto (`disFrecuencias.R`, `tenCentral.R`, `dispersión.R`, `gráficas.R`).  
3. Lee y limpia los datos desde `Data/datos_equipo_5.txt`.  
4. Genera la tabla de frecuencias agrupadas usando la regla de Sturges.  
5. Calcula medidas de tendencia central.  
6. Calcula medidas de dispersión, momentos, sesgo y curtosis.  
7. Guarda todos los data frames en formato `.csv`.  
8. Genera el histograma, la ojiva y el polígono suavizado.  
9. Muestra las tablas en RStudio usando `View()`.

Para ejecutar:

```r
source("main.R")
```

---

## Requisitos

- R (versión recomendada: 4.0 o superior)  
- RStudio (para visualizar las tablas con `View()`)  
- Paquete requerido:

```r
install.packages("ggplot2")
```

---

## Formato del archivo de entrada

El archivo en `Data/` debe ser un `.txt` con números separados por:

- espacios  
- comas  
- punto y coma  
- saltos de línea  

Ejemplo:

```plaintext
10, 12, 12, 15, 18, 19, 21, 21, 21, 25
```

o

```plaintext
10
12
12
15
18
19
21
21
21
25
```

---

## Salidas generadas

**Carpeta Resultados/Data.frames**  
Incluye:

- `Tabla_frecuencias.csv`  
- `Tabla_tendencia_central.csv`  
- `Tabla_dispersion.csv`  
- `Tabla_momentos.csv`  
- `Tabla_sesgo_y_curtosis.csv`  

**Carpeta Resultados/Graficas**  
Incluye (nombres de ejemplo):

- `Histograma_datos_equipo_5.pdf`  
- `Ojiva_datos_equipo_5.pdf`  
- `PoligonoFrecuencias_datos_equipo_5.pdf`  

---

## Objetivo académico

Este proyecto integra los temas y técnicas de la materia de **Estadística Analítica**:

- Construcción de tablas agrupadas (regla de Sturges, marcas de clase, frecuencias)  
- Medidas de tendencia central (media, mediana, moda, medias armónica/geométrica/cuadrática)  
- Medidas de dispersión (varianza, desviación estándar, rango intercuartílico, etc.)  
- Cuantiles y percentiles (cuartiles, percentiles 10 y 90)  
- Momentos estadísticos (al origen, centrales, respecto a mediana y moda)  
- Medidas de forma: asimetría (sesgo) y apuntamiento (curtosis)  
- Gráficas estadísticas principales: histograma, ojiva y polígono suavizado  

Es una herramienta completa para el análisis estadístico descriptivo de un conjunto de datos, con las fórmulas explícitas usadas en cada parte del código.
