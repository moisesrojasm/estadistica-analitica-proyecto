tablas_mtc <- function(tabla_frecuencias) {
  
  total_datos   <- tail(tabla_frecuencias$`F.Acumulada`, 1) # N
  marcas_clase  <- tabla_frecuencias$Marca.de.Clase         # x_j
  frecuencias   <- tabla_frecuencias$Frecuencia             # f_j
  
  # Medias (datos agrupados)
  
  # Media aritmética: mu = sum(f_j * x_j) / N
  media_agrupada <- sum(frecuencias * marcas_clase) / total_datos
  
  # Media armónica: H = N / sum(f_j / x_j)
  media_armonica <- total_datos / sum(frecuencias / marcas_clase)
  
  # Media geométrica: G = exp( sum(f_j * ln(x_j)) / N )
  media_geometrica <- exp(sum(frecuencias * log(marcas_clase)) / total_datos)
  
  # Media cuadrática: RMS = sqrt( sum(f_j * x_j^2) / N )
  media_cuadratica <- sqrt(sum(frecuencias * marcas_clase^2) / total_datos)
  
  # Cuantiles agrupados (para la mediana) Q_p = L_i + A * ((pN - F_a) / f_i)
  
  calcular_cuantil_agrupado <- function(tabla, proporcion_p) {
    objetivo <- proporcion_p * total_datos
    
    # Clase donde cae el cuantil
    indice_clase <- which(tabla$`F.Acumulada` >= objetivo)[1]
    
    limite_inferior     <- tabla$LimInf[indice_clase]
    amplitud_clase      <- tabla$Amplitud[indice_clase]
    frecuencia_clase    <- tabla$Frecuencia[indice_clase]
    
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
  
  # Moda Mo = L_i + A * ( (f_m - f_{m-1}) / ((f_m - f_{m-1}) + (f_m - f_{m+1})) )
  
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
  
  # Data Frame
  
  tabla_mtc <- data.frame(
    Medida = c(
      "Media",
      "Media Armonica",
      "Media Geometrica",
      "Media Cuadratica",
      "Mediana",
      "Moda"
    ),
    Valor  = c(
      media_agrupada,
      media_armonica,
      media_geometrica,
      media_cuadratica,
      mediana_agrupada,
      moda_agrupada
    )
  )
  
  return(tabla_mtc)
}
