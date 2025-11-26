rm(list = ls())

source("Funciones/disFrecuencias.R")
source("Funciones/tenCentral.R")
source("Funciones/dispersión.R")
source("Funciones/gráficas.R")

# Limpieza del dataset

texto_crudo <- paste(readLines("Data/datos_equipo_5.txt"), collapse = " ")

texto_limpio <- gsub("[,;\\n\\t]+", " ", texto_crudo)
texto_limpio <- gsub("\\s+", " ", texto_limpio)

datos_no_agrupados <- as.numeric(strsplit(trimws(texto_limpio), " ", fixed = TRUE)[[1]])

if (any(is.na(datos_no_agrupados))) {
  stop("Error: el archivo contiene valores no numéricos.")
}

# Tabla de frecuencias

tabla_frecuencias_df <- tabla_frecuencias(datos_no_agrupados)
View(tabla_frecuencias_df)

write.csv(
  tabla_frecuencias_df,
  file = file.path("Resultados", "Data.frames", "Tabla_frecuencias.csv"),
  row.names = FALSE
)

# Medidas de tendencia central

tabla_mtc_df <- tablas_mtc(tabla_frecuencias_df)
View(tabla_mtc_df)

write.csv(
  tabla_mtc_df,
  file = file.path("Resultados", "Data.frames", "Tabla_tendencia_central.csv"),
  row.names = FALSE
)

# Dispersión, momento, sesgo y curtosis

resultados_dispersion <- tablas_dispersion(tabla_frecuencias_df)

tabla_dispersion_df <- resultados_dispersion$dispersion   
tabla_momentos_df   <- resultados_dispersion$momentos     
tabla_sesgo_curt_df <- resultados_dispersion$sesgo_curtosis

View(tabla_dispersion_df)
View(tabla_momentos_df)
View(tabla_sesgo_curt_df)

write.csv(
  tabla_dispersion_df,
  file = file.path("Resultados", "Data.frames", "Tabla_dispersion.csv"),
  row.names = FALSE
)

write.csv(
  tabla_momentos_df,
  file = file.path("Resultados", "Data.frames", "Tabla_momentos.csv"),
  row.names = FALSE
)

write.csv(
  tabla_sesgo_curt_df,
  file = file.path("Resultados", "Data.frames", "Tabla_sesgo_y_curtosis.csv"),
  row.names = FALSE
)

# Gráficas

histo(tabla_frecuencias_df, subtitulo = "datos_equipo_5")
ojiva(tabla_frecuencias_df, subtitulo = "datos_equipo_5")

sesgo_pearson2 <- tabla_sesgo_curt_df$Valor[tabla_sesgo_curt_df$Medida == "Sesgo_Pearson_2"]
curtosis_fisher <- tabla_sesgo_curt_df$Valor[tabla_sesgo_curt_df$Medida == "Curtosis_Fisher"]

poligono_frecuencias(
  tabla    = tabla_frecuencias_df,
  sesgo    = sesgo_pearson2,
  curtosis = curtosis_fisher,
  subtitulo = "datos_equipo_5"
)
