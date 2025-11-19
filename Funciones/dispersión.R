tablas_dispersion <- function(tabla, incluir_zscores = FALSE) {
  N  <- tail(tabla$`F.Acumulada`, 1)
  mc <- tabla$Marca.de.Clase
  f  <- tabla$Frecuencia
  
  # Media y mediana (para usar en varias medidas)
  mu <- sum(f * mc) / N
  
  .cuantil_grouped <- function(p){
    objetivo <- p * N
    cls <- which(tabla$`F.Acumulada` >= objetivo)[1]
    Li  <- tabla$LimInf[cls]
    A   <- tabla$Amplitud[cls]
    FA1 <- if (cls == 1) 0 else tabla$`F.Acumulada`[cls - 1]
    f_c <- tabla$Frecuencia[cls]
    Li + A * ((objetivo - FA1) / f_c)
  }
  Me  <- .cuantil_grouped(0.5)
  Q1  <- .cuantil_grouped(0.25)
  Q3  <- .cuantil_grouped(0.75)
  P10 <- .cuantil_grouped(0.10)
  P90 <- .cuantil_grouped(0.90)
  
  RSI <- (Q3 - Q1) / 2
  RSP <- (P90 - P10) / 2
  
  DM_mu <- sum(f * abs(mc - mu)) / N
  DM_Me <- sum(f * abs(mc - Me)) / N
  
  var_pop <- sum(f * (mc - mu)^2) / N
  sd_pop  <- sqrt(var_pop)
  
  CV      <- sd_pop / mu
  Bowley  <- (Q3 - Q1) / (Q3 + Q1)
  
  tabla_disp <- data.frame(
    Medida = c(
      "Q1","Q3","P10","P90",
      "Rango Semi Intercuartilico",
      "Rango Semi Percentil",
      "Desviacion Media (sobre la Media)",
      "Desviacion Media (sobre la Mediana)",
      "Varianza Poblacional",
      "Desviacion Estandar Poblacional",
      "Coeficiente de Dispersion (CV = sd/mu)",
      "Coeficiente de Variacion Cuartil (Bowley)"
    ),
    Valor = c(Q1, Q3, P10, P90, RSI, RSP, DM_mu, DM_Me, var_pop, sd_pop, CV, Bowley)
  )
  
  if (!incluir_zscores) return(list(dispersion = tabla_disp))
  
  zscores <- data.frame(
    Intervalo = tabla$Intervalos.de.Clase,
    Marca     = mc,
    Z         = round((mc - mu) / sd_pop, 4)
  )
  list(dispersion = tabla_disp, z = zscores)
}
