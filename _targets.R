library(targets)
library(tarchetypes)


# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.

source("R-fobbe-proto-package/f.linkextract.R")
source("R-fobbe-proto-package/f.year.iso.R")
source("R-fobbe-proto-package/f.dopar.pdfextract.R")
source("R-fobbe-proto-package/f.hyphen.remove.R")
source("R-fobbe-proto-package/f.fast.freqtable.R")
source("R-fobbe-proto-package/f.lingsummarize.iterator.R")
source("R-fobbe-proto-package/f.dopar.multihashes.R")
source("R-fobbe-proto-package/f.dopar.spacyparse.R")


f.extend <- function(x, y, begin = 0){
    y.ext <- begin:y
    x.ext <- rep(x, length(y.ext))
    dt.out <- list(data.table(x.ext, y.ext))
    return(dt.out)
}

f.extend <- Vectorize(f.extend)



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
