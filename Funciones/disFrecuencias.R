tabla_frecuencias <- function(datos, k = NULL) {
  # Se ordenan los datos y se asegura su tipo de dato
  datos <- sort(as.numeric(datos))
  N <- length(datos)
  
  # Número de clases (regla de Sturges)
  k <- floor(1 + log2(N))

  # Verificar si los datos son enteros
  son_enteros <- all(datos %% 1 == 0)
  
  # Límites inicial y final
  if (son_enteros) {
    lim_inicial <- min(datos) - 0.5
    lim_final   <- max(datos) + 0.5
  } else {
    lim_inicial <- floor(min(datos))
    lim_final   <- ceiling(max(datos))
  }
  
  rango    <- lim_final - lim_inicial
  amplitud <- ceiling(rango / k)
  
  # Secuencia de cortes
  breaks <- seq(
    from = lim_inicial,
    by   = amplitud,
    length.out = k + 1
  )
  
  # Construcción de intervalos y conteo de frecuencias
  cortes <- cut(
    datos,
    breaks = breaks,
    right = TRUE,
    include.lowest = TRUE
  )
  
  lim.inf <- breaks[-length(breaks)]
  lim.sup <- breaks[-1]
  marca   <- (lim.inf + lim.sup) / 2
  
  frecuencia <- as.integer(table(cortes))
  FAcum      <- cumsum(frecuencia)
  
  # Frecuencias
  FRel_exacto     <- frecuencia / N
  FRelAcum_exacto <- cumsum(FRel_exacto)
  
  FRel     <- round(FRel_exacto, 6)
  FRelAcum <- round(FRelAcum_exacto, 6)
  
  Intervalos <- paste(lim.inf, "-", lim.sup)
  
  tabla <- data.frame(
    Intervalos.de.Clase    = Intervalos,
    LimInf                 = lim.inf,
    LimSup                 = lim.sup,
    Amplitud               = rep(amplitud, length(lim.inf)),
    Marca.de.Clase         = marca,
    Frecuencia             = frecuencia,
    "F.Acumulada"          = FAcum,
    "F.Relativa"           = FRel,
    "F.Relativa.Acumulada" = FRelAcum,
    check.names = FALSE
  )
  
  return(tabla)
}
