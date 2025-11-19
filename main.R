rm(list = ls())

source("Funciones/disFrecuencias.R")
source("Funciones/tenCentral.R")
source("Funciones/dispersión.R")
source("Funciones/gráficas.R")

# Lectura flexible
texto <- paste(readLines("Data/datos1.txt"), collapse = " ")
texto <- gsub("[,;\\n\\t]+", " ", texto)
texto <- gsub("\\s+", " ", texto)
mis_datos <- as.numeric(strsplit(trimws(texto), " ", fixed = TRUE)[[1]])

# 1. Tabla de frecuencias
tabla_frec <- tabla_frecuencias(mis_datos)
View(tabla_frec)

# 2. Tendencia central
tabla_mtc <- tablas_mtc(tabla_frec)
View(tabla_mtc)

# 3. Dispersión
tabla_disp <- tablas_dispersion(tabla_frec)$dispersion
View(tabla_disp)

# 4. Gráficas
histo(tabla_frec, subtitulo = "datos1")
ojiva(tabla_frec, subtitulo = "datos1")

message("Listo: tablas mostradas en RStudio y gráficas guardadas en PDF.")
