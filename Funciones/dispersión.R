tablas_dispersion <- function(tabla) {
  # Se extrae N, marcas de clase y frecuencias
  N  <- tail(tabla$`F.Acumulada`, 1)
  mc <- tabla$Marca.de.Clase
  f  <- tabla$Frecuencia
  
  # Media
  mu <- sum(f * mc) / N
  
  # Cuantiles agrupados
  .cuantil_grouped <- function(p) {
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
  
  # Dispersión
  RSI <- (Q3 - Q1) / 2
  RSP <- (P90 - P10) / 2
  
  DM_mu <- sum(f * abs(mc - mu)) / N
  DM_Me <- sum(f * abs(mc - Me)) / N
  
  var_pop <- sum(f * (mc - mu)^2) / N
  sd_pop  <- sqrt(var_pop)
  
  CV <- if (mu == 0) NA else sd_pop / mu
  
  Bowley_disp <- if ((Q3 + Q1) == 0) NA else (Q3 - Q1) / (Q3 + Q1)
  
  tabla_disp <- data.frame(
    Medida = c(
      "Q1","Q3","P10","P90",
      "Rango Semi Intercuartilico",
      "Rango Semi Percentil",
      "Desviacion Media (sobre la Media)",
      "Desviacion Media (sobre la Mediana)",
      "Varianza Poblacional",
      "Desviacion Estandar Poblacional",
      "Coeficiente de Variacion (CV = sd/mu)",
      "Coeficiente Cuartilico de Dispersion (Bowley)"
    ),
    Valor = c(Q1, Q3, P10, P90, RSI, RSP,
              DM_mu, DM_Me, var_pop, sd_pop,
              CV, Bowley_disp)
  )
  tabla_disp$Valor <- round(tabla_disp$Valor, 6)
  
  # Momentos al origen
  m1 <- sum(f * mc) / N
  m2 <- sum(f * mc^2) / N
  m3 <- sum(f * mc^3) / N
  m4 <- sum(f * mc^4) / N
  
  # Momentos centrales respecto a la media
  d_mu <- mc - mu
  mu1 <- 0
  mu2 <- var_pop
  mu3 <- sum(f * d_mu^3) / N
  mu4 <- sum(f * d_mu^4) / N
  
  # Momentos respecto a la mediana
  d_med <- mc - Me
  m1_med <- sum(f * d_med) / N
  m2_med <- sum(f * d_med^2) / N
  m3_med <- sum(f * d_med^3) / N
  m4_med <- sum(f * d_med^4) / N
  
  # Moda agrupada
  cls_mo <- which.max(f)
  Fm   <- f[cls_mo]
  Fm_a <- if (cls_mo == 1) 0 else f[cls_mo - 1]
  Fm_p <- if (cls_mo == length(f)) 0 else f[cls_mo + 1]
  Li_mo <- tabla$LimInf[cls_mo]
  A_mo  <- tabla$Amplitud[cls_mo]
  d1 <- Fm - Fm_a
  d2 <- Fm - Fm_p
  Mo <- Li_mo + A_mo * (d1 / (d1 + d2))
  
  d_mo <- mc - Mo
  m1_mo <- sum(f * d_mo) / N
  m2_mo <- sum(f * d_mo^2) / N
  m3_mo <- sum(f * d_mo^3) / N
  m4_mo <- sum(f * d_mo^4) / N
  
  # Momentos adimensionales
  if (sd_pop == 0) {
    a1 <- a2 <- a3 <- a4 <- NA
    a1_mo <- a2_mo <- a3_mo <- a4_mo <- NA
  } else {
    a1    <- mu1    / sd_pop
    a2    <- mu2    / sd_pop^2
    a3    <- mu3    / sd_pop^3
    a4    <- mu4    / sd_pop^4
    
    a1_mo <- m1_mo  / sd_pop
    a2_mo <- m2_mo  / sd_pop^2
    a3_mo <- m3_mo  / sd_pop^3
    a4_mo <- m4_mo  / sd_pop^4
  }
  
  tabla_momentos <- data.frame(
    Medida = c(
      "m1","m2","m3","m4",
      "mu1","mu2","mu3","mu4",
      "m1_mediana","m2_mediana","m3_mediana","m4_mediana",
      "m1_moda","m2_moda","m3_moda","m4_moda",
      "a1","a2","a3","a4",
      "a1_moda","a2_moda","a3_moda","a4_moda"
    ),
    Valor = c(
      m1, m2, m3, m4,
      mu1, mu2, mu3, mu4,
      m1_med, m2_med, m3_med, m4_med,
      m1_mo, m2_mo, m3_mo, m4_mo,
      a1, a2, a3, a4,
      a1_mo, a2_mo, a3_mo, a4_mo
    )
  )
  tabla_momentos$Valor <- round(tabla_momentos$Valor, 6)
  
  # Sesgo y curtosis
  if (sd_pop == 0) {
    sesgo_pearson1 <- sesgo_pearson2 <- NA
  } else {
    sesgo_pearson1 <- (mu - Mo) / sd_pop
    sesgo_pearson2 <- 3 * (mu - Me) / sd_pop
  }
  
  if ((Q3 - Q1) == 0) {
    sesgo_bowley <- NA
  } else {
    sesgo_bowley <- (Q3 + Q1 - 2 * Me) / (Q3 - Q1)
  }
  
  if ((P90 - P10) == 0) {
    sesgo_kelly <- NA
  } else {
    sesgo_kelly <- (P90 + P10 - 2 * Me) / (P90 - P10)
  }
  
  if (sd_pop == 0) {
    curtosis_fisher <- exceso_curtosis <- NA
  } else {
    curtosis_fisher <- mu4 / sd_pop^4
    exceso_curtosis <- curtosis_fisher - 3
  }
  
  if ((P90 - P10) == 0) {
    curtosis_moors <- NA
  } else {
    curtosis_moors <- (Q3 - Q1) / (P90 - P10)
  }
  
  tabla_forma <- data.frame(
    Medida = c(
      "Sesgo_Pearson_1",
      "Sesgo_Pearson_2",
      "Sesgo_Bowley",
      "Sesgo_Kelly_10_90",
      "Curtosis_Fisher",
      "Curtosis_Exceso",
      "Curtosis_Moors"
    ),
    Valor = c(
      sesgo_pearson1,
      sesgo_pearson2,
      sesgo_bowley,
      sesgo_kelly,
      curtosis_fisher,
      exceso_curtosis,
      curtosis_moors
    )
  )
  tabla_forma$Valor <- round(tabla_forma$Valor, 6)
  
  # Z-scores
  if (sd_pop == 0) {
    Z <- rep(NA, length(mc))
  } else {
    Z <- (mc - mu) / sd_pop
  }
  zscores <- data.frame(
    Intervalo = tabla$Intervalos.de.Clase,
    Marca     = mc,
    Z         = round(Z, 6)
  )
  
  return(list(
    dispersion      = tabla_disp,
    momentos        = tabla_momentos,
    sesgo_curtosis  = tabla_forma,
    z               = zscores
  ))
}
