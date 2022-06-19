

f.var_verfahrensart <- function(x
                                az.brd){

    ## Die Registerzeichen werden an dieser Stelle mit ihren detaillierten Bedeutungen aus dem folgenden Datensatz abgeglichen: "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564." Das Ergebnis des Abgleichs wird in der Variable "verfahrensart" in den Datensatz eingefügt.

    ## Datensatz einlesen
    az.source <- fread(az.source)


    ## Datensatz auf relevante Daten reduzieren
    az.bpatg <- az.source[stelle == "BPatG" & position == "hauptzeichen"]
    
    
    ## Indizes bestimmen
    targetindices <- match(txt.bpatg$registerzeichen,
                           az.bpatg$zeichen_code)
    
    ## Vektor der Verfahrensarten erstellen und einfügen
    verfahrensart <- az.bpatg$bedeutung[targetindices]
    
    
    return(verfahrensart)
    
}





