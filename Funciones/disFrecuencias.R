tabla_frecuencias <- function(datos, k = NULL) {
  # 1) ordenar y asegurar numérico
  datos <- sort(as.numeric(datos))
  N <- length(datos)
  
  # 2) decidir número de clases (K)
  if (is.null(k)) {
    k <- floor(1 + log2(N))  # regla de Sturges
  }
  if (k < 1) k <- 1
  
  # 3) límites y amplitud
  son_enteros <- all(datos %% 1 == 0) # Verificamos que sean datos enteros
  
  
  if (son_enteros) {
    lim_inicial <- min(datos) - 0.5
    lim_final   <- max(datos) + 0.5
  } else {
    lim_inicial <- floor(min(datos))
    lim_final   <- ceiling(max(datos))
  }
  
  rango    <- lim_final - lim_inicial
  amplitud <- ceiling(rango / k)
  
  breaks <- seq(from = lim_inicial,
                by   = amplitud,
                length.out = k + 1)
  
  # 4) intervalos y frecuencias
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
  FRel       <- round(frecuencia / N, 4)
  FRelAcum   <- cumsum(FRel)
  
  Intervalos <- paste(lim.inf, "-", lim.sup)
  
  tabla <- data.frame(
    Intervalos.de.Clase      = Intervalos,
    LimInf                   = lim.inf,
    LimSup                   = lim.sup,
    Amplitud                 = rep(amplitud, length(lim.inf)),
    Marca.de.Clase           = marca,
    Frecuencia               = frecuencia,
    "F.Acumulada"            = FAcum,
    "F.Relativa"             = FRel,
    "F.Relativa.Acumulada"   = FRelAcum,
    check.names = FALSE
  )
  
  return(tabla)
}
