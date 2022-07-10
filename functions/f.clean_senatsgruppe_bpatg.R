#' Spruchkörper säubern (BPatG)
#'
#' Ein Vektor an Spruchkörpern aus der BPatG-Datenbank wird gesäubert, validiert und danach wieder ausgegeben.


#' @param x Character. Rohe Spruchkörper aus der BPatG-Datenbank.

#' @return Character. Spruchgruppe des jeweiligen Senats.



f.clean_senatsgruppe_bpatg <- function(x){

    spruch <- gsub(".*\\(", "", x)
    spruch <- gsub("\\)", "", spruch)
    spruch <- gsub("\\.", "", spruch)
    spruch <- gsub("/", "-", spruch)


    ## Strenge REGEX-Validierung des Aktenzeichens

    regex.test <- grep("[A-Za-z-]+",
                       spruch,
                       invert = TRUE,
                       value = TRUE)


    ## Stoppen falls REGEX-Validierung gescheitert

    if (length(regex.test) != 0){
        stop("REGEX VALIDIERUNG GESCHEITERT: SENATSGRUPPEN ENTSPRECHEN NICHT DEM CODEBOOK-SCHEMA!")
    }
    
    return(spruch)
    
}
