# Proyecto final de mi curso de Estadística Analítica en R  
Análisis de datos con tablas de frecuencias, medidas de tendencia central, dispersión y gráficas estadísticas

Este proyecto implementa un flujo completo de análisis estadístico descriptivo utilizando R.  
El objetivo es procesar un archivo de datos numéricos, generar sus tablas estadísticas y producir gráficas profesionales de frecuencias (histograma y ojiva).

---

## 📁 Estructura del proyecto
Proyecto/
│
├── Data/
│ └── datos1.txt
│
├── Funciones/
│ ├── disFrecuencias.R
│ ├── tenCentral.R
│ ├── dispersión.R
│ └── gráficas.R
│
├── Resultados/
│ └── Graficas/
│ ├── Histograma_datos1.pdf
│ └── Ojiva_datos1.pdf
│
└── main.R

---

## 📌 Descripción de cada módulo

### **1. tablasFrec.R**
Genera la **tabla de distribución de frecuencias** a partir de los datos crudos.  
Incluye:
- Intervalos de clase  
- Límites inferior/superior  
- Amplitud  
- Marca de clase  
- Frecuencia absoluta  
- Frecuencia acumulada  
- Frecuencia relativa  
- Frecuencia relativa acumulada  

Usa la regla de **Sturges** para determinar el número de clases (K) si no se especifica.

---

### **2. tablasMedTenCen.R**
Calcula las **medidas de tendencia central** usando la tabla de frecuencias:

- Media  
- Media armónica  
- Media geométrica  
- Media cuadrática (RMS)  
- Mediana agrupada (por interpolación)  
- Moda agrupada (fórmula de clase modal)

---

### **3. tablasDispersion.R**
Calcula las **medidas de dispersión**, incluyendo:

- Q1, Q3, P10 y P90  
- Rango semi intercuartílico (RSI)  
- Rango semi percentil (RSP)  
- Desviación media respecto a la media  
- Desviación media respecto a la mediana  
- Varianza poblacional  
- Desviación estándar poblacional  
- Coeficiente de dispersión (CV = σ/μ)  
- Coeficiente de variación cuartílica (Bowley)

---

### **4. Graficas.R**
Genera y guarda los gráficos estadísticos:

- **Histograma de frecuencias**  
- **Ojiva (frecuencia relativa acumulada)**  

Las gráficas se exportan en formato **PDF** dentro de `Resultados/Graficas/`.

---

## ▶️ Ejecución del proyecto

Todo el análisis se controla desde `main.R`.

Pasos:

1. Lee el archivo de datos desde `Data/`.
2. Construye la tabla de frecuencias.
3. Calcula las medidas de tendencia central.
4. Calcula las medidas de dispersión.
5. Genera las gráficas y las guarda en PDF.
6. Muestra las tablas en el visor de RStudio (`View()`).

Para ejecutar:

source("main.R")

---

📜 Requisitos

- R (versión 4.0+ recomendada)
- RStudio (opcional, pero recomendado para visualizar tablas con View())

Paquetes usados:

- ggplot2

Instalación de paquetes:

install.packages("ggplot2")
