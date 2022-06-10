

#' @param x Rohe Aktenzeichen aus der BPatG-Datenbank.


f.clean_az_bpatg <- function(x){

    ## An dieser Stelle wird eine mysteriöse Unterstrich-Variante mit einem regulären Unterstrich ersetzt. Es ist mir aktuell unklar um was für eine Art von Zeichen es sich handelt und wieso es in den Daten des Bundespatentgerichts auftaucht. Vermutlich handelt es sich um non-breaking spaces.

    az <- gsub(" ", "_", x)

    az <- gsub("\\/", "_", az.out)
    az <- gsub("\\(", "", az)
    az <- gsub("\\)", "", az)
    az <- sub(" pat", "-pat", az)







## Finale Korrekturen
#' Bei der Entscheidung 1 BGs 29/2009 ist als einzige unter allen Entscheidungen das Eingangsjahr vierstellig und nicht zweistellig, auch im Text der Entscheidung selber. Ich gehe dennoch davon aus, das es sich hier um einen Schreibfehler handelt und nehme eine Korrektur vor.

az <- gsub("1_BGs_29_2009_NA",
                "1_BGs_29_09_NA",
                az)




## Strenge REGEX-Validierung des Aktenzeichens

regex.test1 <- grep("[0-9A-Za]+_[A-Za-zÜ]+_[0-9]+_[0-9]{2}_[A-Za-z]+",
                    az,
                    invert = TRUE,
                    value = TRUE)


## Ergebnis der REGEX-Validierung
print(regex.test1)


## Skript stoppen falls REGEX-Validierung gescheitert

if (length(regex.test1) != 0){
    stop("REGEX VALIDIERUNG GESCHEITERT: AKTENZEICHEN ENTSPRECHEN NICHT DEM CODEBOOK-SCHEMA!")
    }


    return(az)

    }
