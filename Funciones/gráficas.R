suppressPackageStartupMessages(library(ggplot2))

crear_carpeta_si_no_existe <- function(ruta_carpeta) {
  if (!dir.exists(ruta_carpeta)) {
    dir.create(ruta_carpeta, recursive = TRUE)
  }
}

histo <- function(tabla_frecuencias, subtitulo = "") {
  
  ruta_graficas <- file.path("Resultados", "Graficas")
  crear_carpeta_si_no_existe(ruta_graficas)
  
  # Histograma
  grafico_histograma <- ggplot(
    tabla_frecuencias,
    aes(
      x = factor(Intervalos.de.Clase, levels = Intervalos.de.Clase),
      y = Frecuencia
    )
  ) +
    geom_col(color = "black", fill = "steelblue") +
    geom_text(aes(label = Frecuencia), vjust = -0.5) +
    labs(
      title    = "Histograma de Frecuencias",
      subtitle = subtitulo,
      x        = "Intervalo de Clase",
      y        = "Frecuencia"
    ) +
    theme_minimal(base_size = 13)
  
  ggsave(
    filename = file.path(ruta_graficas, sprintf("Histograma_%s.pdf", subtitulo)),
    plot     = grafico_histograma,
    width    = 14,
    height   = 6,
    units    = "in"
  )
  
  return(grafico_histograma)
}

ojiva <- function(tabla_frecuencias, subtitulo = "") {
  
  ruta_graficas <- file.path("Resultados", "Graficas")
  crear_carpeta_si_no_existe(ruta_graficas)
  
  # Ojiva
  grafico_ojiva <- ggplot(
    tabla_frecuencias,
    aes(
      x = factor(Intervalos.de.Clase, levels = Intervalos.de.Clase),
      y = `F.Relativa.Acumulada`,
      group = 1
    )
  ) +
    geom_line(linewidth = 1.2, color = "red") +
    geom_point() +
    geom_text(
      aes(label = `F.Relativa.Acumulada`),
      vjust = -0.5,
      size = 3
    ) +
    labs(
      title    = "Grafica de Ojiva",
      subtitle = subtitulo,
      x        = "Intervalo de Clase",
      y        = "Frecuencia Relativa Acumulada"
    ) +
    theme_minimal(base_size = 13)
  
  ggsave(
    filename = file.path(ruta_graficas, sprintf("Ojiva_%s.pdf", subtitulo)),
    plot     = grafico_ojiva,
    width    = 14,
    height   = 6,
    units    = "in"
  )
  
  return(grafico_ojiva)
}

poligono_frecuencias <- function(tabla_frecuencias,
                                 sesgo,
                                 curtosis,
                                 subtitulo = "") {
  
  ruta_graficas <- file.path("Resultados", "Graficas")
  crear_carpeta_si_no_existe(ruta_graficas)
  
  texto_sesgo <- if (is.na(sesgo)) {
    "Indefinido"
  } else if (sesgo > 0) {
    if (sesgo < 0.2) "Positivo Bajo" else "Positivo"
  } else if (sesgo < 0) {
    if (sesgo > -0.2) "Negativo Bajo" else "Negativo"
  } else {
    "Cero (Simetrico)"
  }
  
  texto_curtosis <- if (is.na(curtosis)) {
    "Indefinida"
  } else if (curtosis < 3) {
    "Platicurtica"
  } else if (curtosis > 3) {
    "Leptocurtica"
  } else {
    "Mesocurtica"
  }
  
  subtitulo_completo <- paste0(
    "Datos: ", subtitulo,
    ",  Sesgo: ", texto_sesgo,
    ",  Curtosis: ", texto_curtosis
  )
  
  # Polígono suavizado
  grafico_poligono <- ggplot(
    tabla_frecuencias,
    aes(x = Marca.de.Clase, y = Frecuencia)
  ) +
    geom_point(color = "red", size = 2) +
    geom_smooth(method = "loess", se = FALSE, linewidth = 1.3,
                color = "red") +
    labs(
      title    = "Poligono de Frecuencias (Suavizado)",
      subtitle = subtitulo_completo,
      x        = "Marca de clase",
      y        = "Frecuencia"
    ) +
    theme_minimal(base_size = 13)
  
  ggsave(
    filename = file.path(ruta_graficas,
                         sprintf("PoligonoFrecuencias_%s.pdf", subtitulo)),
    plot     = grafico_poligono,
    width    = 14,
    height   = 6,
    units    = "in"
  )
  
  return(grafico_poligono)
}
