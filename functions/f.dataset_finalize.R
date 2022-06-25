

#' @param x Der nach Datum sortierte und im Text bereinigte Datensatz.
#' @param downlod.table Die Tabelle mit den Informationen zum Download. Wird mit dem Hauptdatensatz vereinigt.
#' @param aktenzeichen Ein Vektor aus Aktenzeichen.
#' @param ecli Ein Vektor aus ECLIs.
#' @param entscheidung_typ Ein Vektor aus Entscheidungstypen.
#' @param verfahrensart Ein Vektor der jeweiligen Verfahrensarten.




f.dataset_finalize <- function(x,
                               download.table,
                               aktenzeichen,
                               ecli,
                               entscheidung_typ
                               verfahrensart){


    dt <- cbind(x,
                aktenzeichen,
                ecli,
                entscheidung_typ,
                verfahrensart)
    
    
    dt.final <- merge(dt.final,
                      download.table[,.(doc_id,
                                        url,
                                        comment,
                                        leitsatz,
                                        berichtigung,
                                        wirkung,
                                        ruecknahme,
                                        erledigung)],
                      by = "doc_id",
                      all = TRUE)


    return(dt.final)


    
}


## x <- tar_read(dt.bpatg.datecleaned)
## download.table <- tar_read(dt.download.final)


## verfahrensart <- tar_read(var_verfahrensart)
## entscheidung_typ <- tar_read(var_entscheidung_typ)
## aktenzeichen <- tar_read(var_aktenzeichen)
## ecli <- tar_read(var_ecli)