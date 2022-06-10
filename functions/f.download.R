
#' @param x Die für das BPAtG speziell erstellte Download-Tabelle.
#'
#' @return Ein Vektor der Namen der heruntergeladenen PDF-Dateien.
#'
#' 

f.download <- function(x,
                       debug.toggle = FALSE,
                       debug.files = 500){

    ## [Debugging Modus] Reduzierung des Download-Umfangs
    if (debug.toggle == TRUE){
        x <- x[sample(.N,
                      debug.files)]
    }

    ## Ordner erstellen
    dir.create("pdf")

    ## Ordner säubern: Nur in Tabelle enthaltene PDFs dürfen verbleiben
    files.all <- list.files("pdf", full.names = TRUE)
    delete <- setdiff(files.pdf, file.path("pdf", x$filename))
    unlink(delete)

    ## Bereits heruntergeladene Dateien ausklammern
    files.pdf <- list.files("pdf", pattern = "\\.pdf")
    x <- x[!filename %in% files.pdf]
    
    
    ## Download: Erstversuch
    for (i in sample(x[,.N])){
        tryCatch({download.file(url = x$link[i],
                                destfile = file.path("pdf",
                                                     x$filename[i]))
        },
        error = function(cond) {
            return(NA)}
        )
        Sys.sleep(runif(1, 0, 0.1))
    }

    
    ## [Debugging Modus] Löschen zufälliger Dateien
    ## Dient dazu den Wiederholungsversuch zu testen.

    if (debug.toggle == TRUE){
        files.pdf <- list.files("pdf", pattern = "\\.pdf", full.names = TRUE)
        unlink(sample(files.pdf, 5))
    }

    ## Fehlende Dateien
    files.pdf <- list.files("pdf", pattern = "\\.pdf", full.names = TRUE)
    missing <- setdiff(x$filename, basename(files.pdf))


    ## Download: Wiederholungsversuch
    if(length(missing) > 0){

        dt.retry <- x[filename %in% missing]
        
        for (i in 1:dt.retry[,.N]){
            
            response <- GET(dt.retry$link[i])
            
            Sys.sleep(runif(1, 0.25, 0.75))
            
            if (response$headers$"content-type" == "application/pdf" & response$status_code == 200){
                tryCatch({download.file(url = dt.retry$link[i],
                                        destfile = file.path("pdf",
                                                             dt.retry$filename[i]))
                },
                error = function(cond) {
                    return(NA)}
                )     
            }else{
                message(paste0(dt.retry$filenames.final[i], " : kein PDF vorhanden"))  
            }
            Sys.sleep(runif(1, 2, 5))
        } 
    }

    ## Final File Count
    files.pdf <- list.files("pdf", pattern = "\\.pdf", full.names = TRUE)

    return(files.pdf)
    
}
