suppressPackageStartupMessages(library(ggplot2))

.hacer_carpeta <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

histo <- function(tabla, subtitulo = ""){
  .hacer_carpeta(file.path("Resultados","Graficas"))
  
  g <- ggplot(
    tabla,
    aes(x = factor(Intervalos.de.Clase, levels = Intervalos.de.Clase),
        y = Frecuencia)
  ) +
    geom_col(color = "black", fill = "steelblue") +
    geom_text(aes(label = Frecuencia), vjust = -0.5) +
    labs(title = "Histograma de Frecuencias",
         subtitle = subtitulo,
         x = "Intervalo de Clase", y = "Frecuencia") +
    theme_minimal(base_size = 13)
  
  ggsave(file.path("Resultados","Graficas",
                   sprintf("Histograma_%s.pdf", subtitulo)),
         plot = g, width = 14, height = 6, units = "in")
  
  g
}

ojiva <- function(tabla, subtitulo = ""){
  .hacer_carpeta(file.path("Resultados","Graficas"))
  
  g <- ggplot(
    tabla,
    aes(x = factor(Intervalos.de.Clase, levels = Intervalos.de.Clase),
        y = `F.Relativa.Acumulada`, group = 1)
  ) +
    geom_line(linewidth = 1.2, color = "red") +
    geom_point() +
    geom_text(aes(label = `F.Relativa.Acumulada`),
              vjust = -0.5, size = 3) +
    labs(title = "Grafica de Ojiva",
         subtitle = subtitulo,
         x = "Intervalo de Clase",
         y = "Frecuencia Relativa Acumulada") +
    theme_minimal(base_size = 13)
  
  ggsave(file.path("Resultados","Graficas",
                   sprintf("Ojiva_%s.pdf", subtitulo)),
         plot = g, width = 14, height = 6, units = "in")
  
  g
}

# Nuevo: Polígono de Frecuencias (sin suavizado, estilo profesor)
poligono_frecuencias <- function(tabla, sesgo, curtosis, subtitulo = ""){
  .hacer_carpeta(file.path("Resultados","Graficas"))
  
  # Clasificación cualitativa del sesgo
  tipo_sesgo <- if (is.na(sesgo)) {
    "Indefinido"
  } else if (sesgo > 0) {
    if (sesgo < 0.2) "Positivo Bajo" else "Positivo"
  } else if (sesgo < 0) {
    if (sesgo > -0.2) "Negativo Bajo" else "Negativo"
  } else {
    "Cero (Simétrico)"
  }
  
  # Clasificación cualitativa de la curtosis (usando 3 como referencia normal)
  tipo_curtosis <- if (is.na(curtosis)) {
    "Indefinida"
  } else if (curtosis < 3) {
    "Platicúrtica"
  } else if (curtosis > 3) {
    "Leptocúrtica"
  } else {
    "Mesocúrtica"
  }
  
  subt <- paste0(
    "Datos: ", subtitulo,
    ",  Sesgo: ", tipo_sesgo,
    ",  Curtosis: ", tipo_curtosis
  )
  
  g <- ggplot(
    tabla,
    aes(x = Marca.de.Clase, y = Frecuencia)
  ) +
    geom_line(color = "red", linewidth = 1.3) +
    geom_point(color = "red", size = 2) +
    labs(
      title = "Poligono de Frecuencias",
      subtitle = subt,
      x = "Marca de clase",
      y = "Frecuencia"
    ) +
    theme_minimal(base_size = 13)
  
  ggsave(
    file.path("Resultados","Graficas",
              sprintf("PoligonoFrecuencias_%s.pdf", subtitulo)),
    plot = g, width = 14, height = 6, units = "in"
  )
  
  g
}
