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

# 1. disFrecuencias.R  

Construye la **tabla de distribución de frecuencias agrupadas**.

### Número de clases (Sturges)
\\[
k = 1 + \log_2 N
\\]

### Rango
\\[
R = X_{\max} - X_{\min}
\\]

### Amplitud de clase
\\[
c = \frac{R}{k}
\\]

### Marca de clase
\\[
m_j = \frac{L_{j,\text{inf}} + L_{j,\text{sup}}}{2}
\\]

### Frecuencia absoluta
\\[
f_j
\\]

### Frecuencia acumulada
\\[
F_j = \sum_{i=1}^{j} f_i
\\]

### Frecuencia relativa
\\[
h_j = \frac{f_j}{N}
\\]

La tabla se guarda en:  
`Resultados/Data.frames/Tabla_frecuencias.csv`

---

# 2. tenCentral.R  

Cálculo de medidas de tendencia central para datos agrupados.

### Media aritmética (método largo)
\\[
\bar{x} = \frac{1}{N} \sum f_j m_j
\\]

### Media armónica
\\[
H = \frac{N}{\sum \frac{f_j}{m_j}}
\\]

### Media geométrica
\\[
G = \left( \prod m_j^{f_j} \right)^{1/N}
\\]

### Raíz cuadrada media (RCM)
\\[
RCM = \sqrt{\frac{1}{N} \sum f_j m_j^2}
\\]

### Mediana (agrupados)
\\[
Me = L_j + c\left( \frac{\frac{N}{2} - F_{j-1}}{f_j} \right)
\\]

### Moda (agrupados)
\\[
Mo = L_j + c\left( \frac{\Delta_1}{\Delta_1 + \Delta_2} \right)
\\]

Donde:  
\\( \Delta_1 = f_m - f_{m-1} \\)  
\\( \Delta_2 = f_m - f_{m+1} \\)

La tabla se guarda en:  
`Resultados/Data.frames/Tabla_tendencia_central.csv`

---

# 3. dispersión.R  

Incluye las medidas de dispersión, cuantiles, momentos, sesgo y curtosis.

---

## Cuantiles (agrupados)

\\[
Q_k = L + c \left( \frac{qN - F}{f} \right)
\\]

donde:  
- \\( q = k/m \\)  
- \\( F \\) = frecuencia acumulada anterior  
- \\( f \\) = frecuencia de la clase del cuantil  

---

## Rango semi–intercuartílico
\\[
RSI = \frac{Q_3 - Q_1}{2}
\\]

## Rango semi–percentil
\\[
RSP = \frac{P_{90} - P_{10}}{2}
\\]

## Desviación media respecto a la media
\\[
DM_\mu = \frac{1}{N} \sum f_j \, |m_j - \bar{x}|
\\]

## Desviación media respecto a la mediana
\\[
DM_{Me} = \frac{1}{N} \sum f_j \, |m_j - Me|
\\]

## Varianza poblacional
\\[
\sigma^2 = \frac{1}{N} \sum f_j (m_j - \bar{x})^2
\\]

## Desviación estándar
\\[
\sigma = \sqrt{\sigma^2}
\\]

## Coeficiente de variación
\\[
CV = \frac{\sigma}{\bar{x}}
\\]

## Coeficiente cuartílico de dispersión (Bowley)
\\[
C_B = \frac{Q_3 - Q_1}{Q_3 + Q_1}
\\]

Tabla generada en:  
`Resultados/Data.frames/Tabla_dispersion.csv`

---

# Momentos estadísticos

### Momento al origen
\\[
m_k = \frac{1}{N} \sum f_j m_j^k
\\]

### Momento central
\\[
\mu_k = \frac{1}{N} \sum f_j (m_j - \bar{x})^k
\\]

La tabla se guarda en:  
`Resultados/Data.frames/Tabla_momentos.csv`

---

# Sesgo y curtosis

### Sesgo de Pearson 1
\\[
S_1 = \frac{\bar{x} - Mo}{\sigma}
\\]

### Sesgo de Pearson 2
\\[
S_2 = 3\left( \frac{\bar{x} - Me}{\sigma} \right)
\\]

### Curtosis de Fisher
\\[
\beta_2 = \frac{\mu_4}{\sigma^4}
\\]

### Exceso de curtosis
\\[
\gamma_2 = \beta_2 - 3
\\]

Tabla generada en:  
`Resultados/Data.frames/Tabla_sesgo_y_curtosis.csv`

---

# 4. gráficas.R

El módulo genera:

- Histograma  
- Ojiva  
- Polígono de frecuencias suavizado con LOESS  

Todas exportadas como PDF en:  
`Resultados/Graficas/`

---

# Ejecución del proyecto

```r
source("main.R")
```

---

# Requisitos

```r
install.packages("ggplot2")
```

---

# Objetivo académico

Este proyecto integra los temas clave de **Estadística Analítica**, incluyendo:

- Distribuciones de frecuencias  
- Medidas de tendencia central  
- Medidas de dispersión  
- Cuantiles  
- Momentos estadísticos  
- Sesgo y curtosis  
- Gráficas fundamentales  

Es una herramienta completa para análisis descriptivo de datos agrupados.
