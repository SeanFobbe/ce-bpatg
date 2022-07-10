#' Daten säubern und nach Datum sortieren
#'
#' Ein Datensatz mit Datums-Variable und Jahres-Variable wird in ISO-Formate konvertiert und nach Datum sortiert.

#' @param x Eine data.table, die einen Datensatz mit Variable "datum", und "eingangsjahr_az" enthält.

#' @param return Datensatz mit standardisierten Jahresangaben und nach Datum sortiert.



f.clean_dates <- function(x){

    ## Variable "datum" als Datentyp "IDate" kennzeichnen
    x$datum <- as.IDate(x$datum)

    ## Variable "entscheidungsjahr" hinzufügen
    x$entscheidungsjahr <- year(x$datum)

    ## Variable "eingangsjahr_iso" hinzufügen
    x$eingangsjahr_iso <- f.year.iso(x$eingangsjahr_az)

    ## Nach Datum sortieren
    setorder(x,
             datum)

    return(x)
    
}
