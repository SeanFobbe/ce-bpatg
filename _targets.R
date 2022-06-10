## Load Packages
library(targets)
library(tarchetypes)
library(RcppTOML)


## General Options

config <- parseTOML("CE-BPatG_Config.toml")

options(timeout = config$download$timeout)



## Define custom functions

lapply(list.files("functions", full.names = TRUE), source)

source("R-fobbe-proto-package/f.linkextract.R")
source("R-fobbe-proto-package/f.year.iso.R")
source("R-fobbe-proto-package/f.dopar.pdfextract.R")
source("R-fobbe-proto-package/f.hyphen.remove.R")
source("R-fobbe-proto-package/f.fast.freqtable.R")
source("R-fobbe-proto-package/f.lingsummarize.iterator.R")
source("R-fobbe-proto-package/f.dopar.multihashes.R")
source("R-fobbe-proto-package/f.dopar.spacyparse.R")


## Create Directories
dir.create("output")


## Datesttamp
datestamp <- Sys.Date()


## Quellenangabe für Diagramme definieren

caption <- paste("Fobbe | DOI:",
                 config$doi$data$version)


## Präfix für Dateien definieren

prefix.files <- paste0(config$project$shortname,
                       "_",
                       datestamp)


## Präfix für Diagramme definieren

prefix.figuretitle <- paste(config$project$shortname,
                            "| Version",
                            datestamp)



## ZIP-Dateien definieren
zipname.pdf <- paste(prefix.files,
                     "DE_PDF_Datensatz.zip",
                     sep = "_")

zipname.pdf <- file.path("output", zipname.pdf)


zipname.txt <- paste(prefix.files,
                     "DE_TXT_Datensatz.zip",
                     sep = "_")

zipname.txt <- file.path("output", zipname.txt)



files.source.raw <-  c(list.files(pattern = "\\.R$|\\.toml$|\\.md$|\\.Rmd$"),
                   "R-fobbe-proto-package",
                   "data",
                   "functions",
                   "tex",
                   "gpg",
                   "buttons",
                   list.files(pattern = "renv\\.lock|\\.Rprofile",
                              all.files = TRUE),
                   list.files("renv",
                              pattern = "activate\\.R",
                              full.names = TRUE))


zipname.source <- paste0(prefix.files,
                         "_Source_Code.zip")



## Targets Options

tar_option_set(packages = c("fs",           # Verbessertes File Handling
                            "zip",          # Verbessertes ZIP Handling
                            "mgsub",        # Vektorisiertes Gsub
                            "httr",         # HTTP-Werkzeuge
                            "rvest",        # HTML/XML-Extraktion
                            "knitr",        # Professionelles Reporting
                            "kableExtra",   # Verbesserte Kable Tabellen
                            "pdftools",     # Verarbeitung von PDF-Dateien
                            "ggplot2",      # Fortgeschrittene Datenvisualisierung
                            "scales",       # Skalierung von Diagrammen
                            "data.table",   # Fortgeschrittene Datenverarbeitung
                            "readtext",     # TXT-Dateien einlesen
                            "quanteda",     # Fortgeschrittene Computerlinguistik
                            "future",       # Parallelisierung
                            "future.apply"))# Funktionen höherer Ordnung für Parallelisierung



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
    tar_target(files.pdf,
               f.download(dt.download.final,
                          debug.toggle = FALSE,
                          debug.files = 500),
               format = "file"),
    tar_target(files.txt,
               f.pdf_extract_targets(files.pdf),
               format = "file"),

    tar_target(zip.pdf,
               f.zip_targets(files.pdf,
                             zipname.pdf,
                             mode = "cherry-pick"),
               format = "file"),
    
    tar_target(zip.txt,
               f.zip_targets(files.txt,
                             zipname.txt,
                             mode = "cherry-pick"),
               format = "file"),
    tar_target(files.source, files.source.raw),
    tar_target(zip.source,
               f.zip_targets(files.source,
                             zipname.source,
                             mode = "mirror"))
               
)





# todo: rename "spruch" in original downloadtable to "spruchgruppe" when major rerun is in order
