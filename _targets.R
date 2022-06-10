library(targets)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
summ <- function(dataset) {
  summarize(dataset, mean_x = mean(x))
}

## Set target-specific options such as packages.

tar_option_set(packages = "fs",           # Verbessertes File Handling
               "mgsub",        # Vektorisiertes Gsub
               "httr",         # HTTP-Werkzeuge
               "rvest",        # HTML/XML-Extraktion
               "knitr",        # Professionelles Reporting
               "kableExtra",   # Verbesserte Kable Tabellen
               "pdftools",     # Verarbeitung von PDF-Dateien
               "doParallel",   # Parallelisierung
               "ggplot2",      # Fortgeschrittene Datenvisualisierung
               "scales",       # Skalierung von Diagrammen
               "data.table",   # Fortgeschrittene Datenverarbeitung
               "readtext",     # TXT-Dateien einlesen
               "quanteda")     # Fortgeschrittene Computerlinguistik



# End this file with a list of target objects.
list(
  tar_target(data, data.frame(x = sample.int(100), y = sample.int(100))),
  tar_target(summary, summ(data)) # Call your custom functions as needed.
)
