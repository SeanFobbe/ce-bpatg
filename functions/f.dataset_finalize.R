#' Datensatz finalisieren
#'
#' Der BPatG-Datensatz wird mit dieser Funktion um bereits berechnete Variablen angereichert, mit Variablen aus der Download Table verbunden und in Reihenfolge der Variablen-Dokumentation des Codebooks sortiert. Sollten die Anzahl oder die Namen der Variablen von denen im Codebook abweichen wird die Funktion mit einer Fehlermeldung abbrechen.


#' @param x Data.table. Der nach Datum sortierte und im Text bereinigte Datensatz.
#' @param downlod.table Data.table. Die Tabelle mit den Informationen zum Download. Wird mit dem Hauptdatensatz vereinigt.
#' @param vars.additional Data.table. Zusätzliche Variablen, die zuvor extrahiert wurden und nun mit cbind eingehängt werden. Vektoren müssen so geordnet sein wie 'x'.
#' @param varnames Character. Die im Datensatz erlaubten Variablen, in der im Codebook vorgegebenen Reihenfolge.




f.dataset_finalize <- function(x,
                               download.table,
                               files.txt,
                               vars.additional,
                               varnames){

    

    ## Unit Test
    test_that("Argumente entsprechen Erwartungen.", {
        expect_s3_class(x, "data.table")
        expect_s3_class(download.table, "data.table")
        expect_s3_class(vars.additional, "data.table")
        expect_type(varnames, "character")
    })



    ## Bind additional vars
    dt.main <- cbind(x,
                     vars.additional)

    
    ## Merge Download Table

    dt.download.reduced <- download.table[,.(doc_id,
                                             url,
                                             bemerkung,
                                             berichtigung,
                                             wirkung,
                                             ruecknahme,
                                             erledigung)]

    dt.download.reduced$doc_id <- gsub("\\.pdf",
                                       "\\.txt",
                                       dt.download.reduced$doc_id)
    
    
    dt.final <- merge(dt.main,
                      dt.download.reduced,
                      by = "doc_id")


    ## Unit Test: Check if all variables are documented
    varnames <- gsub("\\\\", "", varnames) # Remove LaTeX escape characters
    stopifnot(length(setdiff(names(dt.final), varnames)) == 0)

    ## Order variables as in Codebook
    data.table::setcolorder(dt.final, varnames)


    ## Unit Test
    test_that("Ergebnis entspricht Erwartungen.", {
        expect_s3_class(dt.final, "data.table")
        expect_equal(dt.final[,.N],  x[,.N])
        expect_equal(dt.final[,.N],  length(files.txt))
    })


    return(dt.final)


    
}



## DEBUGGING

## library(data.table)
## library(testthat)
## x  <-  tar_read(dt.bpatg.datecleaned)
## download.table  <-  tar_read(dt.download.final)
## vars.additional <- tar_read(vars_additional)
## varnames  <-  tar_read(variables.codebook)$varname
