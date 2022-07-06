# Corpus der Entscheidungen des Bundespatentgerichts (CE-BPatG)


## Überblick

Das **Corpus der Entscheidungen des Bundespatentgerichts (CE-BPatG)** ist eine möglichst vollständige Sammlung der vom Bundespatentgericht veröffentlichten Entscheidungen. Der Datensatz nutzt als seine Datenquelle die Entscheidungsdatenbank des Bundespatentgerichts und wertet diese vollständig aus.

Alle mit diesem Skript erstellten Datensätze werden dauerhaft kostenlos und urheberrechtsfrei auf Zenodo, dem wissenschaftlichen Archiv des CERN, veröffentlicht. Alle Versionen sind mit einem separaten und langzeit-stabilen (persistenten) Digital Object Identifier (DOI) versehen.

Aktuellster, funktionaler und zitierfähiger Release des Datensatzes: https://doi.org/10.5281/zenodo.3954850



## Funktionsweise

Primäre Endprodukte des Skripts sind folgende ZIP-Archive:
 
- Der volle Datensatz im CSV-Format
- Die reinen Metadaten im CSV-Format (wie unter 1, nur ohne Entscheidungstexte)
- Alle Entscheidungen im TXT-Format (reduzierter Umfang an Metadaten)
- Alle Entscheidungen im PDF-Format (reduzierter Umfang an Metadaten)
- Alle Analyse-Ergebnisse (Tabellen als CSV, Grafiken als PDF und PNG)
- Der Source Code und alle weiteren Quelldaten

Alle Ergebnisse werden im Ordner 'output' abgelegt. Zusätzlich werden für alle ZIP-Archive kryptographische Signaturen (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei hinterlegt. 

Weiterhin kann optional ein PDF-Bericht erstellt werden (siehe unter "Kompilierung").


## Kompilierung

**Achtung:** Verwenden Sie immer einen eigenständigen und *leeren* Ordner für die Kompilierung. Die Skripte löschen innerhalb von bestimmten Unterordnern (txt/, pdf/, temp/ und output/) alle Dateien die den Datensatz verunreinigen könnten --- aber auch nur dort.

1. **Vorbereitung.** Kopieren Sie bitte den gesamten Source Code in einen leeren Ordner (!), beispielsweise mit:

```
git clone https://github.com/seanfobbe/ce-bpatg
```

2. **Installation von *renv*.** Starten sie eine R Session in diesem Ordner, sie sollten automatisch zur Installation von *renv* (package management) aufgefordert werden.

3. **Packages installieren:** um alle packages in der benötigten Version zu installieren, führen Sie in der R session aus:

```
renv::restore()
```

4. **Datensatz erstellen:** den vollständigen Datensatz kompilieren Sie mit folgendem Befehl:

```
rmarkdown::render("CE-BPatG_Compilation.Rmd",
                  output_file = paste0("output/CE-BPatG_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"))
```

5. **Ergebnis:** der Datensatz und alle weiteren Ergebnisse sind nun im Ordner *output/* abgelegt.


## Systemanforderungen

### Betriebssystem

Der Code in seiner veröffentlichten Form kann nur unter Linux ausgeführt werden, da er Linux-spezifische Optimierungen (z.B. Fork Cluster) und Shell-Kommandos (z.B. OpenSSL) nutzt. Der Code wurde unter Fedora Linux entwickelt und getestet. Die zur Kompilierung benutzte Version entnehmen Sie bitte dem sessionInfo()-Ausdruck am Ende des Compilation Reports im Zenodo-Archiv.


### Software

Sie müssen die [Programmiersprache R](https://www.r-project.org/) installiert haben. Starten Sie danach eine Session im Ordner des Projekts, Sie sollten automatisch via **renv** zur Installation aller packages in der empfohlenen Version aufgefordert werden. Andernfalls führen Sie bitte folgenden Befehl aus:

```
renv::restore()
```

Um die PDF Reports zu kompilieren benötigen Sie eine LaTeX-Installation. Sie können diese auf Fedora wie folgt installieren:

```
sudo dnf install texlive-scheme-full
```

Alternativ können sie das R package **tinytex** installieren.


### Parallelisierung

In der Standard-Einstellung wird das Skript vollautomatisch die maximale Anzahl an Rechenkernen/Threads auf dem System zu nutzen. Die Anzahl der verwendeten Kerne kann in der Konfigurationsatei angepasst werden. Wenn die Anzahl Threads auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.


### Speicherplatz

Auf der Festplatte sollten 16 GB Speicherplatz vorhanden sein.

 
 
 
## Weitere Open Access Veröffentlichungen (Fobbe)

Website — https://www.seanfobbe.de

Open Data  —  https://zenodo.org/communities/sean-fobbe-data/

Source Code  —  https://zenodo.org/communities/sean-fobbe-code/

Volltexte regulärer Publikationen  —  https://zenodo.org/communities/sean-fobbe-publications/



## Kontakt

Fehler gefunden? Anregungen? Kommentieren Sie gerne im Issue Tracker auf GitHub oder schreiben Sie mir eine E-Mail an [fobbe-data@posteo.de](fobbe-data@posteo.de)
