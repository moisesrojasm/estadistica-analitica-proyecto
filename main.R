rm(list = ls())

source("Funciones/disFrecuencias.R")
source("Funciones/tenCentral.R")
source("Funciones/dispersión.R")
source("Funciones/gráficas.R")

# Leer el archivo como texto
texto <- paste(readLines("Data/datos_equipo_5.txt"), collapse = " ")

# Reemplazar comas, punto y coma, saltos de línea y tabs por espacios
texto <- gsub("[,;\\n\\t]+", " ", texto)
# Quitar espacios dobles o más
texto <- gsub("\\s+", " ", texto)

# Convertir a numérico
mis_datos <- as.numeric(strsplit(trimws(texto), " ", fixed = TRUE)[[1]])

# Verificar que no haya valores no numéricos
if (any(is.na(mis_datos))) {
  stop("Error: el archivo contiene valores no numéricos.")
}

# 1. Tabla de frecuencias (tbl1.DF)
tbl1.DF <- tabla_frecuencias(mis_datos)
View(tbl1.DF)

write.csv(
  tbl1.DF,
  file = file.path("Resultados", "Data.frames", "Tabla_frecuencias.csv"),
  row.names = FALSE
)

# 2. Tendencia central (tbl2.MTC)
tbl2.MTC <- tablas_mtc(tbl1.DF)
View(tbl2.MTC)

write.csv(
  tbl2.MTC,
  file = file.path("Resultados", "Data.frames", "Tabla_tendencia_central.csv"),
  row.names = FALSE
)

# 3. Dispersión, momentos, sesgo/curtosis, z-scores
res_disp <- tablas_dispersion(tbl1.DF)

tbl3.MD   <- res_disp$dispersion       # Medidas de dispersión
tbl4.Mom  <- res_disp$momentos        # Momentos
tbl5.SyC  <- res_disp$sesgo_curtosis  # Sesgo y curtosis
tbl.Z     <- res_disp$z               # Z-scores por clase

View(tbl3.MD)
View(tbl4.Mom)
View(tbl5.SyC)
View(tbl.Z)

write.csv(
  tbl3.MD,
  file = file.path("Resultados", "Data.frames", "Tabla_dispersion.csv"),
  row.names = FALSE
)

write.csv(
  tbl4.Mom,
  file = file.path("Resultados", "Data.frames", "Tabla_momentos.csv"),
  row.names = FALSE
)

write.csv(
  tbl5.SyC,
  file = file.path("Resultados", "Data.frames", "Tabla_sesgo_y_curtosis.csv"),
  row.names = FALSE
)

write.csv(
  tbl.Z,
  file = file.path("Resultados", "Data.frames", "Zscores_por_clase.csv"),
  row.names = FALSE
)

# 4. Gráficas (histograma, ojiva, polígono de frecuencias)

histo(tbl1.DF, subtitulo = "datos1")
ojiva(tbl1.DF, subtitulo = "datos1")

# Para el polígono de frecuencias se usa sesgo de Pearson 2 y curtosis de Fisher
sesgo_pearson2  <- tbl5.SyC$Valor[tbl5.SyC$Medida == "Sesgo_Pearson_2"]
curtosis_fisher <- tbl5.SyC$Valor[tbl5.SyC$Medida == "Curtosis_Fisher"]

poligono_frecuencias(
  tabla    = tbl1.DF,
  sesgo    = sesgo_pearson2,
  curtosis = curtosis_fisher,
  subtitulo = "datos1"
)

message("Listo: tablas guardadas y 3 gráficas generadas (histograma, ojiva y polígono de frecuencias).")
