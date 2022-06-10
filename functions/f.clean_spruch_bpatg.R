#' @param x Rohe Spruchkörper aus der BPatG-Datenbank.

#' @return Spruchgruppe des jeweiligen Senats.



f.clean_spruch_bpatg <- function(x){

    spruch <- gsub(".*\\(", "", x)
    spruch <- gsub("\\)", "", spruch)
    spruch <- gsub("\\.", "", spruch)
    spruch <- gsub("/", "-", spruch)

    return(spruch)
    
}
