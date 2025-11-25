tablas_mtc <- function(tabla) {
  N  <- tail(tabla$`F.Acumulada`, 1)
  mc <- tabla$Marca.de.Clase
  f  <- tabla$Frecuencia
  
  # Medias
  mu  <- sum(f * mc) / N
  H   <- N / sum(f / mc)
  G   <- exp(sum(f * log(mc)) / N)
  RMS <- sqrt(sum(f * mc^2) / N)
  
  # Función para cuantiles agrupados
  .cuantil_grouped <- function(p){
    objetivo <- p * N
    cls <- which(tabla$`F.Acumulada` >= objetivo)[1]
    Li  <- tabla$LimInf[cls]
    A   <- tabla$Amplitud[cls]
    FA1 <- if (cls == 1) 0 else tabla$`F.Acumulada`[cls - 1]
    f_c <- tabla$Frecuencia[cls]
    Li + A * ((objetivo - FA1) / f_c)
  }
  Me <- .cuantil_grouped(0.5)
  
  # Moda agrupada
  cls_mo <- which.max(f)
  Fm   <- f[cls_mo]
  Fm_a <- if (cls_mo == 1) 0 else f[cls_mo - 1]
  Fm_p <- if (cls_mo == nrow(tabla)) 0 else f[cls_mo + 1]
  Li   <- tabla$LimInf[cls_mo]
  A    <- tabla$Amplitud[cls_mo]
  d1 <- Fm - Fm_a; d2 <- Fm - Fm_p
  Mo <- Li + A * (d1 / (d1 + d2))
  
  data.frame(
    Medida = c("Media","Media Armonica","Media Geometrica",
               "Media Cuadratica","Mediana","Moda"),
    Valor  = c(mu, H, G, RMS, Me, Mo)
  )
}
