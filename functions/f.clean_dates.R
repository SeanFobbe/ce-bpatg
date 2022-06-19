

#' @param x Der frisch mit readtext eingelesene Datensatz.

#' @param return Datensatz mit standardisierten Jahresangaben.



f.clean_dates <- function(x){

    ## Variable "datum" als Datentyp "IDate" kennzeichnen
    x$datum <- as.IDate(x$datum)

    ## Variable "entscheidungsjahr" hinzufügen
    x$entscheidungsjahr <- year(x$datum)

    ## Variable "eingangsjahr_iso" hinzufügen
    x$eingangsjahr_iso <- f.year.iso(x$eingangsjahr_az)
    
}
