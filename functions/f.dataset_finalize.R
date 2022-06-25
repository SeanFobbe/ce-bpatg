


f.dataset_finalize <- function(x,
                               download.table,
                               aktenzeichen,
                               ecli,
                               entscheidung_typ
                               verfahrensart){


    




    
    }


x <- tar_read(dt.bpatg.datecleaned)
download.table <- tar_read(dt.download.final)


verfahrensart <- tar_read(var_verfahrensart)
entscheidung_typ <- tar_read(var_entscheidung_typ)
aktenzeichen <- tar_read(var_aktenzeichen)
ecli <- tar_read(var_ecli)
