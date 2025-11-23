suppressPackageStartupMessages(library(ggplot2))

# Solo para asegurar que los intervalos estén en el orden correcto
.hacer_carpeta <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
}

histo <- function(tabla, subtitulo = "") {
  .hacer_carpeta(file.path("Resultados","Graficas"))
  
  intervalos <- as.character(tabla$Intervalos.de.Clase)
  
  g <- ggplot(
    tabla,
    aes(x = factor(intervalos, levels = intervalos),
        y = Frecuencia)
  ) +
    geom_col(color = "black", fill = "steelblue") +
    geom_text(aes(label = Frecuencia), vjust = -0.5) +
    labs(title = "Histograma de Frecuencias", subtitle = subtitulo,
         x = "Intervalo de Clase", y = "Frecuencia") +
    theme_minimal(base_size = 13)
  
  ggsave(
    file.path("Resultados","Graficas", sprintf("Histograma_%s.pdf", subtitulo)),
    plot = g, width = 14, height = 6, units = "in"
  )
  
  g
}

ojiva <- function(tabla, subtitulo = "") {
  .hacer_carpeta(file.path("Resultados","Graficas"))
  
  intervalos <- as.character(tabla$Intervalos.de.Clase)
  
  g <- ggplot(
    tabla,
    aes(x = factor(intervalos, levels = intervalos),
        y = `F.Relativa.Acumulada`, group = 1)
  ) +
    geom_line(linewidth = 1.2, color = "red") +
    geom_point() +
    geom_text(aes(label = `F.Relativa.Acumulada`), vjust = -0.5, size = 3) +
    labs(title = "Gráfica de Ojiva", subtitle = subtitulo,
         x = "Intervalo de Clase", y = "Frecuencia Relativa Acumulada") +
    theme_minimal(base_size = 13)
  
  ggsave(
    file.path("Resultados","Graficas", sprintf("Ojiva_%s.pdf", subtitulo)),
    plot = g, width = 14, height = 6, units = "in"
  )
  
  g
}
