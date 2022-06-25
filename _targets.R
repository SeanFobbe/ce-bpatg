## Load Packages
library(targets)
library(tarchetypes)
library(RcppTOML)
library(future)
library(data.table)
library(quanteda)


## General Options

config <- parseTOML("CE-BPatG_Config.toml")

options(timeout = config$download$timeout)



## Define custom functions

lapply(list.files("functions", full.names = TRUE), source)

source("R-fobbe-proto-package/f.linkextract.R")
source("R-fobbe-proto-package/f.year.iso.R")
source("R-fobbe-proto-package/f.hyphen.remove.R")
source("R-fobbe-proto-package/f.fast.freqtable.R")
source("R-fobbe-proto-package/f.future_lingsummarize.R")



## Datestamp
datestamp <- Sys.Date()


## Cleanup

### Löscht Dateien im Output-Ordner, die nicht vom heutigen Tag sind
unlink(grep(datestamp,
            list.files("output",
                       full.names = TRUE),
            invert = TRUE,
            value = TRUE))


## Create Directories
#unlink("output", recursive = TRUE)
dir.create("output", showWarnings = FALSE)
dir.create("temp", showWarnings = FALSE)

dir.analysis <- paste0(getwd(),
                       "/analysis")

dir.create(dir.analysis, showWarnings = FALSE)



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



## Metadaten für TXT-Dateien definieren

docvarnames <- c("gericht",
                 "spruchgruppe",
                 "leitsatz",
                 "datum",
                 "spruchkoerper_az",
                 "registerzeichen",
                 "eingangsnummer",
                 "eingangsjahr_az",
                 "zusatz_az",
                 "kollision")





## ZIP-Datei für Source definieren
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



#'## Parallelisierung aktivieren
#' Parallelisierung wird zur Beschleunigung der Konvertierung von PDF zu TXT und der Datenanalyse mittels **quanteda** und **data.table** verwendet. Die Anzahl threads wird automatisch auf das verfügbare Maximum des Systems gesetzt, kann aber auch nach Belieben auf das eigene System angepasst werden. Die Parallelisierung kann deaktiviert werden, indem die Variable **fullCores** auf 1 gesetzt wird.



#+
#'### Anzahl logischer Kerne festlegen

if (config$cores$max == TRUE){
    fullCores <- availableCores()
}


if (config$cores$max == FALSE){
    fullCores <- as.integer(config$cores$number)
}

message(paste("Parallel processing: using", fullCores, "cores."))

#'### Quanteda
quanteda_options(threads = fullCores) 

#'### Data.table
setDTthreads(threads = fullCores)  






## End this file with a list of target objects.

tar.data <- list(tar_target(file.scope,
                            "data/CE-BPatG_Scope.csv",
                            format = "file"),
                 tar_target(scope,
                            fread(file.scope)),
                 tar_target(file.variables,
                            "data/CE-BPatG_Variables.csv",
                            format = "file"),
                 tar_target(variables,
                            fread(file.variables)),
                 tar_target(file.az.brd,
                            "data/AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv",
                            format = "file"),
                 tar_target(az.brd,
                            fread(file.az.brd)),                                 
                tar_target(files.source,
                           files.source.raw,
                           format = "file")
                 )


tar.download <- list(tar_target(dt.download,
                                f.download_table_make(x = scope,
                                                      debug.toggle = config$debug$toggle,
                                                      debug.pages = config$debug$pages)),
                     tar_target(az_clean,
                                f.clean_az_bpatg(dt.download$az)),
                     tar_target(spruchgruppe_clean,
                                f.clean_spruch_bpatg(dt.download$spruch)),
                     tar_target(dt.download.final,
                                f.download_table_finalize(x = dt.download,
                                                          az = az_clean,
                                                          spruchgruppe = spruchgruppe_clean)),
                     tar_target(files.pdf,
                                f.download(url = dt.download.final$url,
                                           filename = dt.download.final$doc_id,
                                           dir = "pdf",
                                           sleep.min = 0,
                                           sleep.max = 0.1,
                                           retries = 3,
                                           retry.sleep.min = 2,
                                           retry.sleep.max = 5,
                                           debug.toggle = FALSE,
                                           debug.files = 500),
                                format = "file")
                     )


tar.convert <- list(tar_target(files.txt,
                               f.pdf_extract_targets(files.pdf),
                               format = "file"),
                    tar_target(dt.bpatg,
                               f.readtext(x = files.txt,
                                          docvarnames = docvarnames))
                    )

tar.enhance <- list(tar_target(dt.bpatg.datecleaned,
                               f.clean_dates(dt.bpatg)),
                    tar_target(var_verfahrensart,
                               f.var_verfahrensart(dt.bpatg.datecleaned$registerzeichen,
                                                   az.brd = az.brd,
                                                   gericht = "BPatG")),
                    tar_target(var_aktenzeichen,
                               f.var_aktenzeichen(dt.bpatg.datecleaned,
                                                  az.brd = az.brd,
                                                  gericht = "BPatG")),
                    tar_target(var_entscheidung_typ,
                               f.var_entscheidung_typ_bpatg(dt.bpatg.datecleaned$text)),
                    tar_target(var_ecli,
                               f.var_ecli_bpatg(dt.bpatg.datecleaned,
                                                entscheidung_typ = var_entscheidung_typ)),
                    tar_target(var_lingstats,
                               f.lingstats(dt.bpatg.datecleaned,
                                           multicore = config$parallel$lingsummarize,
                                           cores = fullCores,
                                           germanvars = TRUE)),
                    tar_target(var_constants,
                               data.frame(version = as.character(datestamp),
                                          doi_concept = config$doi$data$concept,
                                          doi_version = config$doi$data$version,
                                          lizenz = as.character(config$license$data))[rep(1,
                                                                             nrow(dt.bpatg.datecleaned)),]),
                    tar_target(dt.bpatg.full,
                               f.dataset_finalize(dt.bpatg.datecleaned,
                                                  download.table = dt.download.final,
                                                  aktenzeichen = var_aktenzeichen,
                                                  ecli = var_ecli,
                                                  entscheidung_typ = var_entscheidung_typ,
                                                  verfahrensart = var_verfahrensart,
                                                  lingstats = var_lingstats,
                                                  constants = var_constants,
                                                  variablen = variables$variable))
                    )



tar.write  <- list(tar_target(csv.full,
                              f.tar_fwrite(x = dt.bpatg.full,
                                           filename = file.path("output",
                                                                paste0(prefix.files,
                                                                       "_DE_CSV_Datensatz.csv"))
                                           )
                              ),
                   
                   tar_target(csv.meta,
                              f.tar_fwrite(x = dt.bpatg.full[, !"text"],
                                           filename = file.path("output",
                                                                paste0(prefix.files,
                                                                       "_DE_CSV_Metadaten.csv"))
                                           )
                              )
                   )



tar.zip <- list(tar_target(zip.pdf.all,
                           f.zip_targets(files.pdf,
                                         filename = paste(prefix.files,
                                                          "DE_PDF_Datensatz.zip",
                                                          sep = "_"),
                                         dir = "output",
                                         mode = "cherry-pick"),
                           format = "file"),

                tar_target(zip.pdf.leitsatz,
                           f.zip_targets(grep("_LE_", files.pdf, value = TRUE),
                                         filename = paste(prefix.files,
                                                          "DE_PDF_Leitsatz-Entscheidungen.zip",
                                                          sep = "_"),
                                         dir = "output",
                                         mode = "cherry-pick"),
                           format = "file"),
                
                tar_target(zip.txt,
                           f.zip_targets(files.txt,
                                         filename = paste(prefix.files,
                                                          "DE_TXT_Datensatz.zip",
                                                          sep = "_"),
                                         dir = "output",
                                         mode = "cherry-pick"),
                           format = "file"),
                
                tar_target(zip.csv.full,
                           f.zip_targets(csv.full,
                                         filename = gsub("\\.csv", "\\.zip", basename(csv.full)),
                                         dir = "output",
                                         mode = "cherry-pick"),
                           format = "file"),
                tar_target(zip.csv.meta,
                           f.zip_targets(csv.meta,
                                         filename = gsub("\\.csv", "\\.zip", basename(csv.meta)),
                                         dir = "output",
                                         mode = "cherry-pick"),
                           format = "file"),

                tar_target(zip.source,
                           f.zip_targets(files.source,
                                         filename = paste0(prefix.files,
                                                           "_Source_Code.zip"),
                                         dir = "output",
                                         mode = "mirror"),
                           format = "file")
                )



tar.reports <- list(tar_target(latexdefs,
                               f.latexdefs(config,
                                           dir = "temp",
                                           datestamp = datestamp)),
                    tar_render(report.tests,
                               file.path("markdown",
                                         "CE-BPatG_Testreport.Rmd")),
                    tar_render(report.codebook,
                               file.path("markdown",
                                         "CE-BPatG_Codebook.Rmd"))
                    )


list(tar.data,
     tar.download,
     tar.convert,
     tar.enhance,
     tar.write,
     tar.zip,
     tar.reports
     )


## zipname.source <- paste0(prefix.files,
##                          "_Source_Code.zip")

## ## ZIP-Datei für PDF (alle) definieren
## zipname.pdf <- paste(prefix.files,
##                      "DE_PDF_Datensatz.zip",
##                      sep = "_")

## ## ZIP-Datei für PDF (Leitsatzentscheidungen) definieren
## zipname.pdfleitsatz <- paste(prefix.files,
##                              "DE_PDF_Leitsatz-Entscheidungen_Datensatz.zip",
##                              sep = "_")


## ## ZIP-Datei für TXT definieren
## zipname.txt <- paste(prefix.files,
##                      "DE_TXT_Datensatz.zip",
##                      sep = "_")







## todo: rename "spruch" in original downloadtable to "spruchgruppe" when major rerun is in order
## - standardize . and _
## - in download.table sollte der dateiname auch doc_id heißen für easier merge mit späterere voller tabelle
