
#' @param x Download table für das BPatG.
#' @param az Korrigierte Aktenzeichen.
#' @param spruch Korrigierte Spruchgruppen.


f.download_table_finalize <- function(x,
                                      az,
                                      spruchgruppe){


    ## Korrigierte Variablen einfügen

    x$az <- az
    x$spruchgruppe <- spruchgruppe

    ## Einzelkorrektur

    x[az == "27_W-pat_69_08"]$datum <- as.Date("2008-06-03")

    
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
                      x$spruchgruppe,
                      x$leitsatz,
                      x$datum,
                      x$az,
                      sep = "_")

    ## NA einfügen falls EU/EP flag nicht vorhanden
    filename <- ifelse(grepl("(EU|EP)$",
                             filename),
                       filename,
                       paste0(filename, "_NA"))

    
    ## Anzahl Duplikate
    ##length(filename[duplicated(filename)])


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
                                        #filenames1[sample(length(filenames1), 50)]


    ## PDF-Endung anfügen
    filenames2 <- paste0(filenames1,
                         ".pdf")




    ## Strenge REGEX-Validierung: Gesamter Dateiname
    
    regex.test <- grep(paste0("^BPatG",  # gericht
                              "_",
                              "[A-Za-z-]+", # senatsgruppe
                              "_",
                              "(LE|NA)", # leitsatz 
                              "_",
                              "[0-9]{4}-[0-9]{2}-[0-9]{2}", # datum
                              "_",
                              "[0-9]{1,2}", # senatsnummer
                              "_",
                              "((Ni)|(W-pat)|(ZA-pat)|(Li)|(LiQ))", # registerzeichen
                              "_",
                              "[0-9]+", # eingangsnummer
                              "_",
                              "[0-9]{2}", # Ringangsjahr 
                              "_",
                              "EU|EP|NA", # zusatz_az
                              "_",
                              "[0-9]+"), # kollision
                       filenames2,
                       value = TRUE,
                       invert = TRUE)

    
    ## Ergebnis der REGEX-Validierung
                                        #print(regex.test)


    ## Stoppen falls REGEX-Validierung gescheitert

    if (length(regex.test) != 0){
        stop("REGEX VALIDIERUNG GESCHEITERT: DATEINAMEN ENTSPRECHEN NICHT DEM CODEBOOK-SCHEMA!")
    }

    ## Vollen Dateinamen in Download Table einfügen
    x$filename <- filenames2


    ## Return
    return(x)
    
    
}
