
#' @param x Die für das BPAtG speziell erstellte Download-Tabelle.
#'
#' @return Ein Vektor der Namen der heruntergeladenen PDF-Dateien.
#'
#' 

f.download <- function(x,
                       debug.toggle = FALSE
                       debug.files = 500){

    ## [Debugging Modus] Reduzierung des Download-Umfangs

    if (mode.debug == TRUE){
        x <- x[sample(.N,
                      debug.files)]
    }

    ## Ordner stellen
    dir.create("pdf")

    
    
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
        files.pdf <- list.files(pattern = "\\.pdf", full.names = TRUE)
        unlink(sample(files.pdf, 5))
    }
    


    
}









#'## Download: Zwischenergebnis

#+
#'### Anzahl herunterzuladender Dateien
x[,.N]

#'### Anzahl heruntergeladener Dateien
files.pdf <- list.files(pattern = "\\.pdf")
length(files.pdf)

#'### Fehlbetrag
N.missing <- x[,.N] - length(files.pdf)
print(N.missing)

#'### Fehlende Dateien
missing <- setdiff(x$filenames.final, files.pdf)
print(missing)








#'## Wiederholungsversuch: Download
#' Download für fehlende Dokumente wiederholen.

if(N.missing > 0){

    dt.retry <- x[filenames.final %in% missing]
    
    for (i in 1:dt.retry[,.N]){
        response <- GET(dt.retry$link[i])
        Sys.sleep(runif(1, 0.25, 0.75))
        if (response$headers$"content-type" == "application/pdf" & response$status_code == 200){
            tryCatch({download.file(url = dt.retry$link[i],
                                    destfile = dt.retry$filenames.final[i])
            },
            error=function(cond) {
                return(NA)}
            )     
        }else{
            print(paste0(dt.retry$filenames.final[i], " : kein PDF vorhanden"))  
        }
        Sys.sleep(runif(1, 2, 5))
    } 
}






#'## Download: Gesamtergebnis

#+
#'### Anzahl herunterzuladender Dateien
x[,.N]

#'### Anzahl heruntergeladener Dateien
files.pdf <- list.files(pattern = "\\.pdf")
length(files.pdf)

#'### Fehlbetrag
N.missing <- x[,.N] - length(files.pdf)
print(N.missing)

#'### Fehlende Dateien
missing <- setdiff(x$filenames.final, files.pdf)
print(missing)
