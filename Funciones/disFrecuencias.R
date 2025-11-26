tabla_frecuencias <- function(datos) {
  
  datos_numericos <- as.numeric(datos)
  datos_ordenados <- sort(datos_numericos)
  total_datos     <- length(datos_ordenados)
  
  # Número de clases con regla de Sturges
  
  numero_clases <- 1 + log2(total_datos)
  numero_clases <- floor(numero_clases)
  
  # Límites inicial y final de intérvalos
  
  todos_son_enteros <- all(datos_ordenados %% 1 == 0)
  
  if (todos_son_enteros) {
    limite_inicial <- min(datos_ordenados) - 0.5
    limite_final   <- max(datos_ordenados) + 0.5
  } else {
    limite_inicial <- floor(min(datos_ordenados))
    limite_final   <- ceiling(max(datos_ordenados))
  }
  
  rango_datos     <- limite_final - limite_inicial
  amplitud_clase  <- ceiling(rango_datos / numero_clases)
  
  # Cortes en los intérvalos
  
  puntos_corte <- seq(
    from = limite_inicial,
    by   = amplitud_clase,
    length.out = numero_clases + 1
  )
  
  limites_inferiores <- puntos_corte[-length(puntos_corte)]
  limites_superiores <- puntos_corte[-1]
  marcas_clase       <- (limites_inferiores + limites_superiores) / 2
  
  # Contar frecuencias por intérvalo
  
  intervalos_factor <- cut(
    datos_ordenados,
    breaks = puntos_corte,
    right = TRUE,
    include.lowest = TRUE
  )
  
  frecuencias_clase <- as.integer(table(intervalos_factor))
  frecuencia_acum   <- cumsum(frecuencias_clase)
  
  frecuencia_relativa_exacta     <- frecuencias_clase / total_datos
  frecuencia_relativa_acum_exacta <- cumsum(frecuencia_relativa_exacta)
  
  frecuencia_relativa      <- round(frecuencia_relativa_exacta, 6)
  frecuencia_relativa_acum <- round(frecuencia_relativa_acum_exacta, 6)
  
  # Formateo para intérvalos "a - b"
  nombres_intervalos <- paste(limites_inferiores, "-", limites_superiores)
  
  # Construcción de la tabla
  
  tabla_frecuencias_df <- data.frame(
    Intervalos.de.Clase    = nombres_intervalos,
    LimInf                 = limites_inferiores,
    LimSup                 = limites_superiores,
    Amplitud               = rep(amplitud_clase, length(limites_inferiores)),
    Marca.de.Clase         = marcas_clase,
    Frecuencia             = frecuencias_clase,
    "F.Acumulada"          = frecuencia_acum,
    "F.Relativa"           = frecuencia_relativa,
    "F.Relativa.Acumulada" = frecuencia_relativa_acum,
    check.names = FALSE
  )
  
  return(tabla_frecuencias_df)
}
