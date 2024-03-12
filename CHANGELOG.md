# Changelog

## Version \version

- Vollständige Aktualisierung der Daten
- Anpassung von Compose File an Debian 11
- Docker Zeitzone auf Berlin eingestellt


## Version 2023-04-02

- Vollständige Aktualisierung der Daten
- Gesamte Laufzeitumgebung mit Docker versionskontrolliert
- Aktenzeichen aus dem Eingangszeitraum 2000 bis 2009 nun korrekt mit führender Null formatiert (z.B. 1 BvR 44/02 statt 1 BvR 44/2)
- Vereinfachung der Konfigurationsdatei
- Run- und Delete-Skripte aktualisiert
- Neue Funktion für automatischen clean run (Löschung aller Zwischenergebnisse)
- Neuorganisation des Repositories
- Inhalt des ZIP-Archivs mit dem Source Code orientiert sich nun an der Versionskontrolle mit Git und enthält auch die gesamte Git-Historie
- Proto-Package Mono-Repo entfernt, alle Funktionen nun fest projektbasiert versionskontrolliert
- Update der Download-Funktion
- Überflüssige Warnung in f.future_lingsummarize-Funktion entfernt
- Zusätzliche Unit-Tests
- Alle Roh-Dateien werden nun im Ordner "files/" gespeichert
- Verbesserung des Robustness Check Reports
- Verbesserung des Codebooks
- Alle Diagramme neu nummeriert
- Verbesserte Formatierung von Profiling, Warnungen und Fehlermeldungen im Compilation Report
- README im Hinblick auf Docker überarbeitet
- Alle Zwischenergebnisse der Pipeline werden automatisch im Ordner "output/" archiviert
- Umfang der Datenbankabfrage ist nun vollständig automatisiert
- Zwischenergebnisse werden im qs-Format gespeichert um Speicherplatz zu sparen



## Version 2022-07-11

- Vollständige Aktualisierung der Daten
- Neuer Entwurf des gesamten Source Code im {targets} Framework
- Veröffentlichung des Source Codes

## Version 2020-07-20

- Erstveröffentlichung
