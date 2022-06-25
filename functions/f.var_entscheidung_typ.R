

#' @param x Ein Vektor aus Strings ("Character"), die den Text von Entscheidungen des Bundespatentgerichts enthalten.
#'
#' @param return Ein Vektor aller Entscheidungstypen. Entweder "B" für Beschluss oder "U" für Urteil.


f.var_entscheidung_typ_bpatg <- function(x){

    ## Entscheidungstyp extrahieren
    entscheidung_typ <- stringi::stri_extract_first(str = x,
                                                    regex = paste0(gsub(" ", " *", "B E S C H L U S S"),
                                                                   "|",
                                                                   gsub(" ", " *", "U R T E I L")),
                                                    case_insensitive = TRUE)

    ## Auf einzelnen Buchstaben reduzieren
    entscheidung_typ <- gsub("([BU]).+",
                             "\\1",
                             toupper(entscheidung_typ))

    ## Strenger Test
    if (any(!entscheidung_typ %in% c("B", "U"))){

        stop("Fehler: Nicht alle Entscheidungstypen sind entweder 'U' oder 'B'.")
        
    }

    
    return(entscheidung_typ)
    
    
}
