# Limpia entorno
rm(list = ls())

# Carga las funciones
source("Funciones/disFrecuencias.R")
source("Funciones/tenCentral.R")
source("Funciones/dispersión.R")
source("Funciones/gráficas.R")


texto <- paste(readLines("Data/datos_equipo_5.txt"), collapse = " ")
texto <- gsub("[,;\n\t]+", " ", texto)  # se reemplazan separadores por espacio
texto <- gsub("\\s+", " ", texto)       # se colapsan espacios múltiples
mis_datos <- as.numeric(strsplit(trimws(texto), " ", fixed = TRUE)[[1]])

# Validamos datos numéricos
if (any(is.na(mis_datos))) {
  stop("Error: El archivo contiene valores no numéricos.")
}

# 1. Tabla de frecuencias
tabla_frec <- tabla_frecuencias(mis_datos)
View(tabla_frec)
write.csv(
  tabla_frec,
  "Resultados/Data.frames/Tabla_frecuencias.csv",
  row.names = FALSE
)

# 2. Medidas de tendencia central
tabla_mtc <- tablas_mtc(tabla_frec)
View(tabla_mtc)
write.csv(
  tabla_mtc,
  "Resultados/Data.frames/Tabla_tendencia_central.csv",
  row.names = FALSE
)

# 3. Medidas de dispersión, momentos, sesgo y curtosis
res_disp <- tablas_dispersion(tabla_frec, incluir_zscores = FALSE)
tabla_disp <- res_disp$dispersion
View(tabla_disp)
write.csv(
  tabla_disp,
  "Resultados/Data.frames/Tabla_dispersion_momentos_sesgo_curtosis.csv",
  row.names = FALSE
)

# Solo en caso de que incluir_zscores = TRUE
if (!is.null(res_disp$z)) {
  write.csv(
    res_disp$z,
    "Resultados/Data.frames/Zscores_por_clase.csv",
    row.names = FALSE
  )
}

# 4. Gráficas
histo(tabla_frec, subtitulo = "datos1")
ojiva(tabla_frec, subtitulo = "datos1")

message("Listo: tablas guardadas en Resultados/Data.frames y gráficas en Resultados/Graficas.")
