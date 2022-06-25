

#' @param x Der nach Datum sortierte und im Text bereinigte Datensatz.
#' @param downlod.table Die Tabelle mit den Informationen zum Download. Wird mit dem Hauptdatensatz vereinigt.
#' @param aktenzeichen Ein Vektor aus Aktenzeichen.
#' @param ecli Ein Vektor aus ECLIs.
#' @param entscheidung_typ Ein Vektor aus Entscheidungstypen.
#' @param verfahrensart Ein Vektor der jeweiligen Verfahrensarten.
#' @param variablen Die im Datensatz erlaubten Variablen, in der im Codebook vorgegebenen Reihenfolge.




f.dataset_finalize <- function(x,
                               download.table,
                               aktenzeichen,
                               ecli,
                               entscheidung_typ,
                               verfahrensart,
                               variablen){


    dt.main <- cbind(x,
                     aktenzeichen,
                     ecli,
                     entscheidung_typ,
                     verfahrensart)

    dt.download.reduced <- download.table[,.(doc_id,
                                             url,
                                             comment,
                                             berichtigung,
                                             wirkung,
                                             ruecknahme,
                                             erledigung)]

    dt.download.reduced$doc_id <- gsub("\\.pdf", "\\.txt", dt.download.reduced$doc_id)
    
    
    dt.final <- merge(dt.main,
                      dt.download.reduced,
                      by = "doc_id")

    variablen <- gsub("\\\\", "", variablen)

    
    #data.table::setcolorder(dt.final, variablen)


    return(dt.final)


    
}


## x <- tar_read(dt.bpatg.datecleaned)
## download.table <- tar_read(dt.download.final)


## verfahrensart <- tar_read(var_verfahrensart)
## entscheidung_typ <- tar_read(var_entscheidung_typ)
## aktenzeichen <- tar_read(var_aktenzeichen)
## ecli <- tar_read(var_ecli)
## variablen <- tar_read(variables)$variable
