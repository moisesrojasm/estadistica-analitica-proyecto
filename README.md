# Proyecto de Estadística Analítica en R  
Análisis completo de datos agrupados: frecuencias, tendencia central, dispersión, momentos, sesgo, curtosis y gráficas estadísticas.

Este proyecto procesa un archivo con datos numéricos, genera todas las tablas estadísticas importantes y produce gráficas profesionales (histograma y ojiva).
Todas las tablas se guardan automáticamente en la carpeta **Resultados/Data.frames** en formato `.csv`.

---

## Estructura del proyecto

```plaintext
Proyecto/
│
├── Data/
│   └── datos_equipo_5.txt
│
├── Funciones/
│   ├── disFrecuencias.R          # Tabla de distribución de frecuencias
│   ├── tenCentral.R              # Medidas de tendencia central
│   ├── dispersión.R              # Dispersión + momentos + sesgo + curtosis + z-scores
│   └── gráficas.R                # Histograma y ojiva
│
├── Resultados/
│   ├── Data.frames/
│   │   ├── Tabla_frecuencias.csv
│   │   ├── Tabla_tendencia_central.csv
│   │   ├── Tabla_dispersion_momentos_sesgo_curtosis.csv
│   │
│   └── Graficas/
│       ├── Histograma_datos1.pdf
│       └── Ojiva_datos1.pdf
│
└── main.R
```

---

## Descripción de cada módulo

### **1. disFrecuencias.R**
Construye la **tabla de distribución de frecuencias agrupadas**, usando la regla de Sturges para determinar el número de clases.

Produce:
- Intervalos de clase  
- Límite inferior
- Límite superior  
- Amplitud  
- Marca de clase  
- Frecuencia absoluta  
- Frecuencia acumulada  
- Frecuencia relativa  
- Frecuencia relativa acumulada  

La tabla se guarda en:
`Resultados/Data.frames/Tabla_frecuencias.csv`

### **2. tenCentral.R**
Calcula las principales **medidas de tendencia central** para datos agrupados:

- Media aritmética  
- Media armónica  
- Media geométrica  
- Media cuadrática (RMS)  
- Mediana agrupada (se interpola dentro de la clase)  
- Moda agrupada (fórmula de clase modal)

La tabla se guarda en:
`Resultados/Data.frames/Tabla_tendencia_central.csv`

### **3. dispersión.R**
Combina varias áreas: **dispersión**, **momentos**, **sesgo** y **curtosis**:

**A. Medidas de dispersión**

- Cuartiles: Q1, Q3
- Percentiles: P10, P90
- Rango semi intercuartílico (RSI)  
- Rango semi percentil (RSP)  
- Desviación media respecto a la media  
- Desviación media respecto a la mediana  
- Varianza poblacional  
- Desviación estándar poblacional  
- Coeficiente de variación (CV)  
- Coeficiente cuartílico de dispersión 

**B. Momentos estadísticos**

- Momentos al origen: m1, m2, m3, m4
- Momentos centrales respecto a la media: μ1, μ2, μ3, μ4
- Momentos respecto a la mediana
- Momentos respecto a la moda
- Momentos adimensionales (a₁, a₂, a₃, a₄), usando desviación estándar poblacional 

**C. Medidas de forma: sesgo y curtosis**

- Sesgo de Pearson 1
- Sesgo de Pearson 2
- Sesgo cuartílico de Bowley
- Sesgo percentil de Kelly (P10-P90)
- Curtosis de Fisher
- Exceso de curtosis
- Curtosis percentil de Moors

La tabla se guarda en:
`Resultados/Data.frames/Tabla_dispersion_momentos_sesgo_curtosis.csv`

---

### **4. gráficas.R**
Genera:

- **Histograma de frecuencias**  
- **Ojiva (frecuencia relativa acumulada)**  

Ambas exportadas en **PDF** a:
`Resultados/Graficas/`

---

## Ejecución del proyecto

Todo se ejecuta desde `main.R`.

Pasos:

1. Limpia el entorno.
2. Carga los módulos del proyecto.
3. Lee y limpia los datos desde `Data/`.
4. Genera la tabla de frecuencias.
5. Calcula todas las medidas de tendencia central.
6. Calcula dispersión, momentos, sesgo, curtosis y z-scores.
7. Guarda todos los data frames en `.csv`.
8. Produce las gráficas.
9. Muestra las tablas en RStudio con `View()`

Para ejecutar:

```r
source("main.R")
```

---

## Requisitos

- R (4.0 o superior recomendada)
- RStudio (para visualizar tablas con View())
- Paquetes usados:
  - ggplot2

Instalar:

```r
install.packages("ggplot2")
```

---

## Formato del archivo de entrada

El archivo en `Data/` debe ser un `.txt` con números separados por:

- espacios
- comas
- saltos de línea
- punto y coma

Ejemplos:

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
Contiene:

- Tabla_dispersion_momentos_sesgo_curtosis.csv
- Tabla_frecuencias.csv
- Tabla_tendencia_central.csv
- Zscores_por_clase.csv

**Carpeta Resultados/Graficas**
Contiene:

- Histograma_datos1.pdf
- Ojiva_datos1.pdf

---

## Objetivo académico

Este proyecto integra de forma práctica todos los temas centrales de lamateria de Estadística Analítica:

- Tablas de frecuencia agrupadas
- Tendencia central
- Dispersión
- Cuantiles y percentiles
- Momentos estadísticos
- Asimetría y curtosis
- Estandarización (z-scores)
- Visualización de datos

Es una herramienta completa para el análisis estadístico descriptivo de un conjunto de datos.
