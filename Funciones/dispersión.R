tablas_dispersion <- function(tabla, incluir_zscores = FALSE) {
  # N: total de datos
  N  <- tail(tabla$`F.Acumulada`, 1)
  
  # mc: marcas de clase, f: frecuencias
  mc <- tabla$Marca.de.Clase
  f  <- tabla$Frecuencia
  
  # Media (se usará para muchas medidas)
  mu <- sum(f * mc) / N
  
  # Función interna para cuantiles agrupados
  .cuantil_grouped <- function(p) {
    objetivo <- p * N
    cls <- which(tabla$`F.Acumulada` >= objetivo)[1]
    Li  <- tabla$LimInf[cls]
    A   <- tabla$Amplitud[cls]
    FA1 <- if (cls == 1) 0 else tabla$`F.Acumulada`[cls - 1]
    f_c <- tabla$Frecuencia[cls]
    Li + A * ((objetivo - FA1) / f_c)
  }
  
  # Mediana y cuantiles
  Me  <- .cuantil_grouped(0.5)
  Q1  <- .cuantil_grouped(0.25)
  Q3  <- .cuantil_grouped(0.75)
  P10 <- .cuantil_grouped(0.10)
  P90 <- .cuantil_grouped(0.90)
  
  # Rangos semi-intercuartílico y semi-percentil
  RSI <- (Q3 - Q1) / 2
  RSP <- (P90 - P10) / 2
  
  # Desviaciones medias (respecto a media y mediana)
  DM_mu <- sum(f * abs(mc - mu)) / N
  DM_Me <- sum(f * abs(mc - Me)) / N
  
  # Momentos al origen (1 a 4)
  m1 <- sum(f * mc) / N
  m2 <- sum(f * mc^2) / N
  m3 <- sum(f * mc^3) / N
  m4 <- sum(f * mc^4) / N
  
  # Momentos respecto a la media (centrales)
  mu1 <- 0
  mu2 <- sum(f * (mc - mu)^2) / N
  mu3 <- sum(f * (mc - mu)^3) / N
  mu4 <- sum(f * (mc - mu)^4) / N
  
  # Varianza y desviación estándar poblacionales
  var_pop <- mu2
  sd_pop  <- sqrt(var_pop)
  
  # Momentos respecto a la mediana
  mMed1 <- sum(f * (mc - Me)) / N
  mMed2 <- sum(f * (mc - Me)^2) / N
  mMed3 <- sum(f * (mc - Me)^3) / N
  mMed4 <- sum(f * (mc - Me)^4) / N
  
  # Momentos adimensionales (usando momentos centrales)
  # a1 = mu1 / sd, a2 = mu2 / sd^2, etc.
  if (sd_pop == 0) {
    a1 <- NA
    a2 <- NA
    a3 <- NA
    a4 <- NA
  } else {
    a1 <- mu1 / sd_pop
    a2 <- mu2 / sd_pop^2  # normalmente = 1
    a3 <- mu3 / sd_pop^3
    a4 <- mu4 / sd_pop^4
  }
  
  # Coeficiente de variación
  CV <- if (mu == 0) NA else sd_pop / mu
  
  # Moda agrupada (para sesgo de Pearson)
  cls_mo <- which.max(f)
  Fm   <- f[cls_mo]
  Fm_a <- if (cls_mo == 1) 0 else f[cls_mo - 1]
  Fm_p <- if (cls_mo == length(f)) 0 else f[cls_mo + 1]
  Li_mo <- tabla$LimInf[cls_mo]
  A_mo  <- tabla$Amplitud[cls_mo]
  d1 <- Fm - Fm_a
  d2 <- Fm - Fm_p
  if ((d1 + d2) == 0) {
    Mo <- mc[cls_mo]
  } else {
    Mo <- Li_mo + A_mo * (d1 / (d1 + d2))
  }
  
  # Sesgos de Pearson
  if (sd_pop == 0) {
    Pearson1 <- NA
    Pearson2 <- NA
  } else {
    Pearson1 <- (mu - Mo) / sd_pop
    Pearson2 <- 3 * (mu - Me) / sd_pop
  }
  
  # Sesgo cuartílico de Bowley (versión de sesgo)
  if ((Q3 - Q1) == 0) {
    Sesgo_Bowley <- NA
  } else {
    Sesgo_Bowley <- (Q3 + Q1 - 2 * Me) / (Q3 - Q1)
  }
  
  # Sesgo percentil de Kelly (10-90)
  if ((P90 - P10) == 0) {
    Sesgo_Kelly <- NA
  } else {
    Sesgo_Kelly <- (P90 + P10 - 2 * Me) / (P90 - P10)
  }
  
  # Curtosis de Fisher y exceso
  if (sd_pop == 0) {
    Curtosis_Fisher <- NA
    Exceso_Curtosis <- NA
  } else {
    Curtosis_Fisher <- mu4 / sd_pop^4
    Exceso_Curtosis <- Curtosis_Fisher - 3
  }
  
  # Curtosis percentil de Moors
  if ((P90 - P10) == 0) {
    Curtosis_Moors <- NA
  } else {
    Curtosis_Moors <- (Q3 - Q1) / (P90 - P10)
  }
  
  # Tabla principal: dispersión + momentos + sesgo + curtosis
  tabla_disp <- data.frame(
    Medida = c(
      # Posición y dispersión clásica
      "Q1","Q3","P10","P90",
      "Rango Semi Intercuartilico",
      "Rango Semi Percentil",
      "Desviacion Media (sobre la Media)",
      "Desviacion Media (sobre la Mediana)",
      "Varianza Poblacional",
      "Desviacion Estandar Poblacional",
      "Coeficiente de Variacion (CV = sd/mu)",
      
      # Momentos al origen
      "Momento 1 al Origen (m1)",
      "Momento 2 al Origen (m2)",
      "Momento 3 al Origen (m3)",
      "Momento 4 al Origen (m4)",
      
      # Momentos respecto a la media
      "Momento Central 1 (mu1)",
      "Momento Central 2 (mu2)",
      "Momento Central 3 (mu3)",
      "Momento Central 4 (mu4)",
      
      # Momentos respecto a la mediana
      "Momento respecto a la Mediana 1",
      "Momento respecto a la Mediana 2",
      "Momento respecto a la Mediana 3",
      "Momento respecto a la Mediana 4",
      
      # Momentos adimensionales
      "Momento Adimensional 1 (a1)",
      "Momento Adimensional 2 (a2)",
      "Momento Adimensional 3 (a3)",
      "Momento Adimensional 4 (a4)",
      
      # Sesgos
      "Coeficiente de Sesgo de Pearson 1",
      "Coeficiente de Sesgo de Pearson 2",
      "Coeficiente Cuartil de Sesgo (Bowley)",
      "Coeficiente de Sesgo Percentil 10-90 (Kelly)",
      
      # Curtosis
      "Curtosis de Fisher",
      "Exceso de Curtosis",
      "Curtosis Percentil de Moors"
    ),
    Valor = c(
      # Posición y dispersión clásica
      Q1, Q3, P10, P90,
      RSI, RSP, DM_mu, DM_Me,
      var_pop, sd_pop, CV,
      
      # Momentos al origen
      m1, m2, m3, m4,
      
      # Momentos respecto a la media
      mu1, mu2, mu3, mu4,
      
      # Momentos respecto a la mediana
      mMed1, mMed2, mMed3, mMed4,
      
      # Momentos adimensionales
      a1, a2, a3, a4,
      
      # Sesgos
      Pearson1, Pearson2, Sesgo_Bowley, Sesgo_Kelly,
      
      # Curtosis
      Curtosis_Fisher, Exceso_Curtosis, Curtosis_Moors
    )
  )
  
  # Redondea resultados a 6 decimales
  tabla_disp$Valor <- round(tabla_disp$Valor, 6)
  
  # Si no se piden z-scores, regresa solo la tabla de dispersion/momentos
  if (!incluir_zscores) {
    return(list(dispersion = tabla_disp))
  }
  
  # Tabla de z-scores por marca de clase
  zscores <- data.frame(
    Intervalo = tabla$Intervalos.de.Clase,
    Marca     = mc,
    Z         = if (sd_pop == 0) NA else round((mc - mu) / sd_pop, 6)
  )
  
  return(list(dispersion = tabla_disp, z = zscores))
}
