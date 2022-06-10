#' @param x Rohe Spruchkörper aus der BPatG-Datenbank.

#' @return Spruchgruppe des jeweiligen Senats.



f.clean_spruch_bpatg <- function(x){

    spruch <- gsub(".*\\(", "", x)
    spruch <- gsub("\\)", "", spruch)
    spruch <- gsub("\\.", "", spruch)
    spruch <- gsub("/", "-", spruch)


    ## Strenge REGEX-Validierung des Aktenzeichens

    regex.test <- grep("[A-Za-z-]+",
                       az,
                       invert = TRUE,
                       value = TRUE)


    ## Stoppen falls REGEX-Validierung gescheitert

    if (length(regex.test) != 0){
        stop("REGEX VALIDIERUNG GESCHEITERT: SPRUCHKÖRPER ENTSPRECHEN NICHT DEM CODEBOOK-SCHEMA!")
    }
    
    return(spruch)
    
}
