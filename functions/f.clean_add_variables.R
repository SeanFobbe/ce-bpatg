
#' @param x Download table für das BPatG.
#' @param az Korrigierte Aktenzeichen.
#' @param spruch Korrigierte Spruchgruppen.


f.clean_add_variables <- function(x,
                                  az,
                                  spruch){





    ## Variable "leitsatz" erstellen

    x$leitsatz <- ifelse(grepl("Leitsatz",
                               x$comment,
                               ignore.case = TRUE),
                         "LE",
                         "NA")

    
    ## Variable "berichtigung" erstellen

    x$berichtigung <- ifelse(grepl("berichtigung",
                                   x$comment,
                                   ignore.case = TRUE),
                             TRUE,
                             FALSE)

    ## Variable "wirkung" erstellen

    x$wirkung <- ifelse(grepl("Wirkungslos",
                              x$comment,
                              ignore.case = TRUE),
                        FALSE,
                        TRUE)

    ## Variable "ruecknahme" erstellen

    x$ruecknahme <- ifelse(grepl("zurückgenommen",
                                 x$comment,
                                 ignore.case = TRUE),
                           TRUE,
                           FALSE)

    
    ## Variable "erledigung" erstellen

    x$erledigung <- ifelse(grepl("erledigt|Erledigung",
                                 x$comment,
                                 ignore.case = TRUE),
                           TRUE,
                           FALSE)

    

    
    ## Dateinamen erstellen

    filename <- paste("BPatG",
                      x$spruch,
                      x$leitsatz,
                      x$datum,
                      x$az,
                      sep = "_")

    
## Anzahl Duplikate
##length(filename[duplicated(filename)])
    

## KollisionsID einfügen


## Kollisions-IDs vergeben
filenames1 <- make.unique(filename, sep = "-----")


indices <- grep("-----",
                filenames1,
                invert = TRUE)

values <- grep("-----",
               filenames1,
               invert = TRUE,
               value = TRUE)

filenames1[indices] <- paste0(values,
                              "_0")

filenames1 <- gsub("-----",
                   "_",
                   filenames1)

## Zufällige Auswahl zur Prüfung anzeigen
filenames1[sample(length(filenames1), 50)]


## PDF-Endung anfügen
filenames2 <- paste0(filenames1,
                    ".pdf")




## Strenge REGEX-Validierung: Gesamter Dateiname

regex.test2 <-grep("BPatG_.*_[NALE]{2}_[0-9]{4}-[0-9]{2}-[0-9]{2}_[A-Za-z0-9]*_[A-Za-zÜ]*_[0-9-]*_[0-9]{2}_[A-Za-z]*_.*_[NA0-9]*.pdf",
     filenames2,
     value = TRUE,
     invert = TRUE)


## Ergebnis der REGEX-Validierung
print(regex.test2)


## Skript stoppen falls REGEX-Validierung gescheitert

if (length(regex.test2) != 0){
    stop("REGEX VALIDIERUNG GESCHEITERT: DATEINAMEN ENTSPRECHEN NICHT DEM CODEBOOK-SCHEMA!")
    }

## Vollen Dateinamen in Download Table einfügen
x$filenames.final <- filenames2
    
    
    }
