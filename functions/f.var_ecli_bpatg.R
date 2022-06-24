

#' Die Struktur der ECLI des BPatG ist nicht dokumentiert, lautet aber vermutlich wie folgt: "ECLI:DE:BPatG:[entscheidungsjahr_iso]:[entscheidungstag][entscheidungsmonat][entscheidungsjahr][entscheidungstyp][senatsnummer][registerzeichen][eingangsnummer].[eingangsjahr].[kollisionsziffer]". Beispiel: "ECLI:DE:BPatG:2022:200622B28Wpat546.21.0".


#' @param x Ein juristischer Datensatz als data.table mit den Variablen "spruchkoerper_az", "registerzeichen", "eingangsnummer", "eingangsjahr_az".

#' @param az.brd Ein data.frame oder data.table mit dem Datensatz "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564."


#' @param return Ein Vektor mit ECLIs für das Bundespatentgericht. Achtung: alle ECLIs die sich nur in der Kollisionsziffer unterscheiden sind potentiell fehlerhaft, da mir aktuell keine Möglichkeit bekannt ist die originale Vergabe der Kollisionsziffer zu reproduzieren.




f.var_ecli_bpatg <- function(x){


    ecli <-  paste0("ECLI:DE:BPatG:",
                    x$entscheidungsjahr,
                    ":",
                    format(x$datum,
                           "%d%m%y"),
                    "???",
                    x$spruchkoerper_az,
                    gsub("-", "", x$registerzeichen),
                    x$eingangsnummer,
                    ".",
                    x$eingangsjahr_az,
                    ".",
                    x$kollision)
    



    }
