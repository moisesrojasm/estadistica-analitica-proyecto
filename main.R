# ============================================
# Proyecto de Estadística - Estructura inicial
# ============================================

rm(list = ls())

# Cargar librerías (aunque aún no las uses)
# library(here)

# Cargar funciones (archivos vacíos)
# Estas líneas no fallarán si los archivos existen aunque estén vacíos
source("Funciones/Función_1.R")
source("Funciones/Función_2.R")
source("Funciones/Función_3.R")

# Leer datos (archivo vacío o inexistente no debe romper el script hoy)
# Crea un vector de ejemplo por ahora
mis_datos <- c(10, 20, 30, 40, 50)

# Imprimir algo mínimo para comprobar que corre
print("Estructura del proyecto cargada correctamente.")
print(mis_datos)

