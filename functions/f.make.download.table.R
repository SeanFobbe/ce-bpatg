
#' Diese Funktion wertet die Entscheidungsdatenbank des Bundespatentgerichts aus und sammelt Links zu den Entscheidungsvolltexten und verbindet sie mit den in der Datenbank angegebenen Metadaten.

#' @param x Der Umfang der Datenbankseiten, der berücksichtigt werden soll
#' @param debug.toggle Ob der Debugging-Modus aktiviert werden soll. Im Debugging-Modus wird nur eine reduzierte Anzahl Datenbankseiten ausgewertet. Jede Seite enthält idR 30 Entscheidungen.
#' @param deubg.pages Anzahl der auszuwertenden Datenbankseiten.


#' @return Eine Tabelle mit allen Links und in der Datenbank verfügbaren Metadaten.




f.make.download.table <- function(x,
                                  debug.toggle = FALSE,
                                  debug.pages = 50){


    ## Genauen Such-Umfang berechnen

    scope <- f.extend(x$year,
                      x$pagemax0)


    scope <- rbindlist(scope)

    setnames(scope,
             c("year",
               "page"))


    ## Locator einfügen

    scope[, loc := {
        loc <- paste0(year, "-", page)
        list(loc)
    }]

    
    ## [Debugging Modus] Reduzierung des Such-Umfangs

    if (debug.toggle == TRUE){
        scope <- scope[sample(scope[,.N], debug.scope)][order(year, page)]
    }



    ## Metadaten extrahieren
    
    meta.all.list <- vector("list",
                            scope[,.N])

    scope.random <- sample(scope[,.N])

    for (i in seq_along(scope.random)){
        
        year <- scope$year[scope.random[i]]
        page <- scope$page[scope.random[i]]

        URL  <- paste0("https://juris.bundespatentgericht.de/cgi-bin/rechtsprechung/list.py?Gericht=bpatg&Art=en&Datum=",
                       year,
                       "&Seite=",
                       page)
        
        html <- read_html(URL)
        
        link <-  html_nodes(html, "a" )%>% html_attr('href')
        
        link <- grep ("Blank=1.pdf",
                      link,
                      ignore.case = TRUE,
                      value = TRUE)
        
        link <- sprintf("https://juris.bundespatentgericht.de/cgi-bin/rechtsprechung/%s",
                        link)
        

        datum <- html_nodes(html, "[class='EDatum']") %>% html_text(trim = TRUE)

        spruch <- html_nodes(html, "[class='ESpruchk']") %>% html_text(trim = TRUE)
        
        az <- html_nodes(html, "[class='EAz']") %>% html_text(trim = TRUE)

        comment <- html_nodes(html, "[class='ETitel']") %>% html_text(trim = TRUE)

        meta.all.list[[scope.random[i]]] <- data.table(year,
                                                       page,
                                                       link,
                                                       datum,
                                                       spruch,
                                                       az,
                                                       comment)

        remaining <- length(scope.random) - i
        
        if ((remaining %% 10^2) == 0){
            message(paste(Sys.time(), "| Noch", remaining , "verbleibend."))
        }

        if((i %% 100) == 0){
            Sys.sleep(runif(1, 5, 15))
        }else{
            Sys.sleep(runif(1, 1.5, 2.5))
        }    
    }

    
    ## Zusammenfügen
    dt.download <- rbindlist(meta.all.list)

    
    ## Datum bereinigen
    dt.download[, datum := {
        datum <- as.character(datum)
        datum <- as.IDate(datum, "%d.%m.%Y")
        list(datum)}]
    

    return(dt.download)

}







