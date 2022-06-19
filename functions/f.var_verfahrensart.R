

f.var_verfahrensart <- function(x,
                                az.brd,
                                gericht){

    ## Die Registerzeichen werden an dieser Stelle mit ihren detaillierten Bedeutungen aus dem folgenden Datensatz abgeglichen: "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564." Das Ergebnis des Abgleichs wird in der Variable "verfahrensart" in den Datensatz eingefügt.

    ## Datensatz einlesen
    az.source <- fread(az.source)


    ## Datensatz auf relevante Daten reduzieren
    az.gericht <- az.source[stelle == gericht & position == "hauptzeichen"]
    
    
    ## Indizes bestimmen
    targetindices <- match(x$registerzeichen,
                           az.gericht$zeichen_code)
    
    ## Vektor der Verfahrensarten erstellen und einfügen
    verfahrensart <- az.gericht$bedeutung[targetindices]
    
    
    return(verfahrensart)
    
}





