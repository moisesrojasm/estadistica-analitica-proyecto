tabla_frecuencias <- function(datos, k = NULL) {
  # Ordena los datos y se asegura de que sean numéricos
  datos <- sort(as.numeric(datos))
  N <- length(datos)
  
  # Decide el número de clases con la regla de Sturges si no se especifica k
  if (is.null(k)) {
    k <- floor(1 + log2(N))
  }
  if (k < 1) k <- 1
  
  # Revisa si los datos son enteros
  son_enteros <- all(datos %% 1 == 0)
  
  # Define límites inicial y final del rango
  if (son_enteros) {
    lim_inicial <- min(datos) - 0.5
    lim_final   <- max(datos) + 0.5
  } else {
    lim_inicial <- floor(min(datos))
    lim_final   <- ceiling(max(datos))
  }
  
  rango    <- lim_final - lim_inicial
  amplitud <- ceiling(rango / k)
  
  # Secuencia de puntos de corte (breaks)
  breaks <- seq(
    from = lim_inicial,
    by   = amplitud,
    length.out = k + 1
  )
  
  # Crea los intervalos y calcula frecuencias
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
  FRel       <- round(frecuencia / N, 6)      # 6 decimales
  FRelAcum   <- round(cumsum(FRel), 6)        # 6 decimales
  
  # Texto de intervalos de clase
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
