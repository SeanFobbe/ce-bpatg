## Load Packages
library(targets)
library(tarchetypes)
library(RcppTOML)

## Read config file
config <- parseTOML("CE-BPatG_Config.toml")


## Define custom functions and other global objects.

source("R-fobbe-proto-package/f.linkextract.R")
source("R-fobbe-proto-package/f.year.iso.R")
source("R-fobbe-proto-package/f.dopar.pdfextract.R")
source("R-fobbe-proto-package/f.hyphen.remove.R")
source("R-fobbe-proto-package/f.fast.freqtable.R")
source("R-fobbe-proto-package/f.lingsummarize.iterator.R")
source("R-fobbe-proto-package/f.dopar.multihashes.R")
source("R-fobbe-proto-package/f.dopar.spacyparse.R")


lapply(list.files("functions", full.names = TRUE), source)



## Set target-specific options such as packages.

tar_option_set(packages = c("fs",           # Verbessertes File Handling
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
                            "quanteda"))     # Fortgeschrittene Computerlinguistik



## End this file with a list of target objects.


list(
    tar_target(scopefile,
               "data/CE-BPatG_Scope.csv",
               format = "file"),
    tar_target(scope,
               fread(scopefile)),
    tar_target(dt.download, f.make.download.table(x = scope,
                                                  debug.toggle = config$debug$toggle,
                                                  debug.pages = config$debug$pages)),
    tar_target(az_clean, f.clean_az_bpatg(dt.download$az)),
    tar_target(spruchgruppe_clean, f.clean_spruch_bpatg(dt.download$spruch)),
    tar_target(dt.download.final, f.clean_add_variables(x = dt.download,
                                                        az = az_clean,
                                                        spruchgruppe = spruchgruppe_clean)),
    tar_target(files.pdf, f.download(dt.download.final,
                                     debug.toggle = FALSE,
                                     debug.files = 500),
               format = "file")
               
)


# todo: rename "spruch" in original downloadtable to "spruchgruppe" when major rerun is in order
