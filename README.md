# README: Corpus der Entscheidungen des Bundespatentgerichts (CE-BPatG)


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


## Anleitung

Diese Anleitung führt die Schritt für Schritt durch die Erstellung des Datensatzes. 


### Systemanforderungen

- Nur mit Fedora Linux getestet. Vermutlich auch funktionsfähig unter anderen Linux-Distributionen.
- 16 GB Speicherplatz auf Festplatte
- Multi-core CPU stark empfohlen (8 cores/16 threads für die Referenzdatensätze). In der Standard-Einstellung wird das Skript vollautomatisch die maximale Anzahl an Rechenkernen/Threads auf dem System zu nutzen. Die Anzahl der verwendeten Kerne kann in der Konfigurationsatei angepasst werden. Wenn die Anzahl Threads auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.



### Ordner vorbereiten

Kopieren Sie bitte den gesamten Source Code in einen leeren Ordner (!), beispielsweise mit:

```
git clone https://github.com/seanfobbe/ce-bpatg
```

Verwenden Sie immer einen eigenständigen und *leeren* Ordner für die Kompilierung. Die Skripte löschen innerhalb von bestimmten Unterordnern (txt/, pdf/, temp/ und output/) alle Dateien die den Datensatz verunreinigen könnten --- aber auch nur dort.



### Installation der Programmiersprache 'R'

Sie müssen die [Programmiersprache R](https://www.r-project.org/) installiert haben.



### Installation von 'renv'

Starten sie eine R Session in diesem Ordner, sie sollten automatisch zur Installation von [renv](https://rstudio.github.io/renv/articles/renv.html) (Tool zur Versionierung von R packages) aufgefordert werden.



### Installation von R Packages

Um alle packages in der benötigten Version zu installieren, führen Sie in der R session aus:

```
renv::restore()   # in einer R-Konsole ausführen
```

**Achtung:** es reicht nicht, die Packages auf herkömmliche Art installiert zu haben. Sie müssen dies nochmal über [renv](https://rstudio.github.io/renv/articles/renv.html) tun, selbst wenn die Packages in ihrer normalen Library schon vorhanden sind.



### Installation von LaTeX

Um die PDF Reports zu kompilieren benötigen Sie eine LaTeX-Installation. Sie können diese auf Fedora wie folgt installieren:

```
sudo dnf install texlive-scheme-full
```

Alternativ können sie das R package **tinytex** installieren:

```
install.packages("tinytex")   # in einer R-Konsole ausführen
```



### Datensatz erstellen

Den vollständigen Datensatz kompilieren Sie mit folgendem Befehl:

```
rmarkdown::render("CE-BPatG_Compilation.Rmd",
                  output_file = paste0("output/CE-BPatG_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"))
```


### Ergebnis

Der Datensatz und alle weiteren Ergebnisse sind nun im Ordner *output/* abgelegt.



### Pipeline visualisieren

Sie können die Pipeline visualisieren, aber nur nachdem sie die zentrale .Rmd-Datei mindestens einmal gerendert haben:

```
targets::tar_glimpse()     # Nur Datenobjekte
targets::tar_visnetwork()  # Alle Objekte
```


### Troubleshooting

Hilfreiche Befehle um Fehler zu lokalisieren und zu beheben.

```
tar_progress() %>% print(n=100)   # Zeigt Fortschritt und Fehler an
tar_meta() %>% print(n=100)       # Metadaten inspizieren
tar_meta(fields = "warnings", complete_only = TRUE) # Zeigt Targets mit Warnungen an
tar_meta(fields = "error", complete_only = TRUE)   # Zeigt Targets mit Fehlermeldungen an
tar_meta(fields = "seconds") %>% print(n=40)      # Zeit Laufzeit der Targets an
```





## Projektstruktur

Die folgende Struktur erläutert die wichtigsten Bestandteile des Projekts. Währen der Kompilierung werden weitere Ordner erstellt (`pdf/`, `txt/`, `temp/` und `output/`). Die Endergebnisse werden alle in `output/` abgelegt.

 
``` 
├── CE-BPatG_Compilation.Rmd   # Zentrale Definition der Pipeline
├── CE-BPatG_Config.toml       # Zentrale Konfigurations-Datei
├── R-fobbe-proto-package      # Oft verwendete Funktionen 
├── _targets_packages.R        # Automatisiert erstellte Package-Liste für renv
├── buttons                    # Buttons (nur optische Bedeutung)
├── data                       # Datensätze, auf denen die Pipeline aufbaut
├── functions                  # Wichtige Schritte der Pipeline
├── gpg                        # Persönlicher Public GPG-Key für Seán Fobbe
├── renv                       # Versionskontrolle: Executables
├── renv.lock                  # Versionskontrolle: Versionsinformationen
├── reports                    # Markdown-Dateien
└── tex                        # LaTeX-Templates

```




 
## Weitere Open Access Veröffentlichungen (Fobbe)

Website — https://www.seanfobbe.de

Open Data  —  https://zenodo.org/communities/sean-fobbe-data/

Source Code  —  https://zenodo.org/communities/sean-fobbe-code/

Volltexte regulärer Publikationen  —  https://zenodo.org/communities/sean-fobbe-publications/



## Kontakt

Fehler gefunden? Anregungen? Kommentieren Sie gerne im Issue Tracker auf GitHub oder schreiben Sie mir eine E-Mail an [fobbe-data@posteo.de](fobbe-data@posteo.de)
