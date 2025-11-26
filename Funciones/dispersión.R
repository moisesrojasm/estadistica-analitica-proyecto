tablas_dispersion <- function(tabla_frecuencias) {
  
  total_datos   <- tail(tabla_frecuencias$`F.Acumulada`, 1)
  marcas_clase  <- tabla_frecuencias$Marca.de.Clase
  frecuencias   <- tabla_frecuencias$Frecuencia
  
  media_agrupada <- sum(frecuencias * marcas_clase) / total_datos
  
  # Cuantiles agrupados
  
  calcular_cuantil_agrupado <- function(tabla, proporcion_p) {
    objetivo <- proporcion_p * total_datos
    indice_clase <- which(tabla$`F.Acumulada` >= objetivo)[1]
    
    limite_inferior <- tabla$LimInf[indice_clase]
    amplitud_clase  <- tabla$Amplitud[indice_clase]
    frecuencia_clase <- tabla$Frecuencia[indice_clase]
    
    if (indice_clase == 1) {
      frecuencia_acum_anterior <- 0
    } else {
      frecuencia_acum_anterior <- tabla$`F.Acumulada`[indice_clase - 1]
    }
    
    cuantil <- limite_inferior +
      amplitud_clase * ((objetivo - frecuencia_acum_anterior) / frecuencia_clase)
    
    return(cuantil)
  }
  
  mediana_agrupada <- calcular_cuantil_agrupado(tabla_frecuencias, 0.50)
  cuartil_1        <- calcular_cuantil_agrupado(tabla_frecuencias, 0.25)
  cuartil_3        <- calcular_cuantil_agrupado(tabla_frecuencias, 0.75)
  percentil_10     <- calcular_cuantil_agrupado(tabla_frecuencias, 0.10)
  percentil_90     <- calcular_cuantil_agrupado(tabla_frecuencias, 0.90)
  
  # Medidas de dispersión
  
  rango_semi_intercuartilico <- (cuartil_3 - cuartil_1) / 2
  rango_semi_percentilico    <- (percentil_90 - percentil_10) / 2
  
  desviacion_media_media <- sum(frecuencias * abs(marcas_clase - media_agrupada)) / total_datos
  desviacion_media_mediana <- sum(frecuencias * abs(marcas_clase - mediana_agrupada)) / total_datos
  
  varianza_poblacional <- sum(frecuencias * (marcas_clase - media_agrupada)^2) / total_datos
  desviacion_estandar_poblacional <- sqrt(varianza_poblacional)
  
  if (media_agrupada == 0) {
    coeficiente_variacion <- NA
  } else {
    coeficiente_variacion <- desviacion_estandar_poblacional / media_agrupada
  }
  
  if ((cuartil_3 + cuartil_1) == 0) {
    coeficiente_bowley_disp <- NA
  } else {
    coeficiente_bowley_disp <- (cuartil_3 - cuartil_1) / (cuartil_3 + cuartil_1)
  }
  
  tabla_dispersion <- data.frame(
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
    Valor = c(
      cuartil_1, cuartil_3, percentil_10, percentil_90,
      rango_semi_intercuartilico, rango_semi_percentilico,
      desviacion_media_media, desviacion_media_mediana,
      varianza_poblacional, desviacion_estandar_poblacional,
      coeficiente_variacion, coeficiente_bowley_disp
    )
  )
  tabla_dispersion$Valor <- round(tabla_dispersion$Valor, 6)
  
  # Momentos
  
  momento_1_origen <- sum(frecuencias * marcas_clase)     / total_datos
  momento_2_origen <- sum(frecuencias * marcas_clase^2)   / total_datos
  momento_3_origen <- sum(frecuencias * marcas_clase^3)   / total_datos
  momento_4_origen <- sum(frecuencias * marcas_clase^4)   / total_datos
  
  desviaciones_media <- marcas_clase - media_agrupada
  momento_1_central  <- 0
  momento_2_central  <- varianza_poblacional
  momento_3_central  <- sum(frecuencias * desviaciones_media^3) / total_datos
  momento_4_central  <- sum(frecuencias * desviaciones_media^4) / total_datos
  
  desviaciones_mediana <- marcas_clase - mediana_agrupada
  momento_1_mediana <- sum(frecuencias * desviaciones_mediana)     / total_datos
  momento_2_mediana <- sum(frecuencias * desviaciones_mediana^2)   / total_datos
  momento_3_mediana <- sum(frecuencias * desviaciones_mediana^3)   / total_datos
  momento_4_mediana <- sum(frecuencias * desviaciones_mediana^4)   / total_datos
  
  indice_moda <- which.max(frecuencias)
  frecuencia_moda      <- frecuencias[indice_moda]
  frecuencia_anterior  <- if (indice_moda == 1) 0 else frecuencias[indice_moda - 1]
  frecuencia_posterior <- if (indice_moda == length(frecuencias)) 0 else frecuencias[indice_moda + 1]
  
  limite_inferior_moda <- tabla_frecuencias$LimInf[indice_moda]
  amplitud_moda        <- tabla_frecuencias$Amplitud[indice_moda]
  
  diferencia_1 <- frecuencia_moda - frecuencia_anterior
  diferencia_2 <- frecuencia_moda - frecuencia_posterior
  
  moda_agrupada <- limite_inferior_moda +
    amplitud_moda * (diferencia_1 / (diferencia_1 + diferencia_2))
  
  desviaciones_moda <- marcas_clase - moda_agrupada
  momento_1_moda <- sum(frecuencias * desviaciones_moda)     / total_datos
  momento_2_moda <- sum(frecuencias * desviaciones_moda^2)   / total_datos
  momento_3_moda <- sum(frecuencias * desviaciones_moda^3)   / total_datos
  momento_4_moda <- sum(frecuencias * desviaciones_moda^4)   / total_datos
  
  if (desviacion_estandar_poblacional == 0) {
    a1_media <- a2_media <- a3_media <- a4_media <- NA
    a1_moda  <- a2_moda  <- a3_moda  <- a4_moda  <- NA
  } else {
    a1_media <- momento_1_central / desviacion_estandar_poblacional
    a2_media <- momento_2_central / desviacion_estandar_poblacional^2
    a3_media <- momento_3_central / desviacion_estandar_poblacional^3
    a4_media <- momento_4_central / desviacion_estandar_poblacional^4
    
    a1_moda  <- momento_1_moda / desviacion_estandar_poblacional
    a2_moda  <- momento_2_moda / desviacion_estandar_poblacional^2
    a3_moda  <- momento_3_moda / desviacion_estandar_poblacional^3
    a4_moda  <- momento_4_moda / desviacion_estandar_poblacional^4
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
      momento_1_origen, momento_2_origen, momento_3_origen, momento_4_origen,
      momento_1_central, momento_2_central, momento_3_central, momento_4_central,
      momento_1_mediana, momento_2_mediana, momento_3_mediana, momento_4_mediana,
      momento_1_moda, momento_2_moda, momento_3_moda, momento_4_moda,
      a1_media, a2_media, a3_media, a4_media,
      a1_moda, a2_moda, a3_moda, a4_moda
    )
  )
  tabla_momentos$Valor <- round(tabla_momentos$Valor, 6)
  
  # Sesgo y curtosis
  
  if (desviacion_estandar_poblacional == 0) {
    sesgo_pearson_1 <- sesgo_pearson_2 <- NA
  } else {
    sesgo_pearson_1 <- (media_agrupada - moda_agrupada) / desviacion_estandar_poblacional
    sesgo_pearson_2 <- 3 * (media_agrupada - mediana_agrupada) / desviacion_estandar_poblacional
  }
  
  if ((cuartil_3 - cuartil_1) == 0) {
    sesgo_bowley <- NA
  } else {
    sesgo_bowley <- (cuartil_3 + cuartil_1 - 2 * mediana_agrupada) / (cuartil_3 - cuartil_1)
  }
  
  if ((percentil_90 - percentil_10) == 0) {
    sesgo_kelly <- NA
  } else {
    sesgo_kelly <- (percentil_90 + percentil_10 - 2 * mediana_agrupada) /
      (percentil_90 - percentil_10)
  }
  
  if (desviacion_estandar_poblacional == 0) {
    curtosis_fisher <- exceso_curtosis <- NA
  } else {
    curtosis_fisher <- momento_4_central / desviacion_estandar_poblacional^4
    exceso_curtosis <- curtosis_fisher - 3
  }
  
  if ((percentil_90 - percentil_10) == 0) {
    curtosis_moors <- NA
  } else {
    curtosis_moors <- (cuartil_3 - cuartil_1) / (percentil_90 - percentil_10)
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
      sesgo_pearson_1,
      sesgo_pearson_2,
      sesgo_bowley,
      sesgo_kelly,
      curtosis_fisher,
      exceso_curtosis,
      curtosis_moors
    )
  )
  tabla_forma$Valor <- round(tabla_forma$Valor, 6)
  
  return(list(
    dispersion     = tabla_dispersion,
    momentos       = tabla_momentos,
    sesgo_curtosis = tabla_forma
  ))
}
