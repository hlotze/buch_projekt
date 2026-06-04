# Buchprojekte strukturieren

## Motivation

Sie

- wollen ein Buch schreiben und
- benötigen noch eine gewisse Struktur zum Vorgehen,
- sind Mac- oder Linux-affin und
- arbeiten gerne an
  - der Console,
  - mit Scripten oder
  - auch einem Makfile,
- Ihr Editor ist VS Code,
- Sie bevorzugen Markdown Dateien, und
- erstellen PDF und EPUB mit `pandoc`?

dann kann dieses Tool mit seinem Script und Makefile ein möglicher Einstieg sein.

Viel Erfolg

---

## Setup & Nutzung

Dieses Verzeichnis enthält zwei Dateien:

- `create_book_project.sh` – legt die komplette Buchprojekt-Struktur an  
- `Makefile` – automatisiert wiederkehrende Aufgaben im Projekt

Beide Dateien können in **jedem beliebigen Ordner** liegen und von dort genutzt werden. Dort werden Sie am Buch arbeiten.

---

### Voraussetzungen

- Unix-Shell (z. B. macOS Terminal, Linux Shell)
- `bash` verfügbar
- Optional für erweiterte Funktionen:
  - [`yq`](https://mikefarah.gitbook.io/yq/) (YAML-Tool)
  - [`pandoc`](https://pandoc.org/) (für PDF/EPUB/DOCX-Build)

---

### Erstes Einrichten – Projekt anlegen

1. **Dateien kopieren**

    Kopiere `create_book_project.sh` und `Makefile` in ein beliebiges Verzeichnis, z. B.:

    ```bash
    mkdir -p ~/Schreiben/MeinSetup
    cp create_book_project.sh Makefile ~/Schreiben/MeinSetup
    cd ~/Schreiben/MeinSetup
    ```

2. **Das Script**

    1. Script ausführbar machen (optional, aber praktisch)

        ```bash
        chmod +x create_book_project.sh
        ```

    2. Projekt mit **Standardnamen** anlegen

        ```bash
        ./create_book_project.sh
        ```

        → erzeugt ein Projektverzeichnis:

        ```text
        buchprojekt/
            Kapitel/
            Fragmente/
            Plot/
            Welt/
            Recherche/
            Themen/
            ...
        ```

    3. Projekt mit **eigenem Namen** anlegen

        ```bash
        ./create_book_project.sh MeinRoman
        ```

        → erzeugt:

        ```text
        MeinRoman/
            Kapitel/
            Fragmente/
            Plot/
            Welt/
            Recherche/
            Themen/
            ...
        ```

### Das Makefile

Ein `make help` zeigt Ihnen die vorhandenen Optionen:

```text
📘 Verfügbare Makefile-Befehle:

help:                 Zeigt diese Hilfe an
new-kapitel:          Neues Kapitel anlegen
new-fragment:         Neues Fragment anlegen
stats:                Wortstatistik anzeigen
check:                Prüft auf fehlende '# Titel'-Zeilen
backup:               Erstellt ein ZIP-Backup des Projekts
build:                Baut alle Ausgabeformate
pdf:                  Erzeugt PDF mit Pandoc
epub:                 Erzeugt EPUB mit Pandoc
docx:                 Erzeugt DOCX mit Pandoc
index:                Erzeugt Kapitelindex aus YAML
```

## eBook lesen

Das mit `pandoc` erstelltes eBook im Format epub, können Sie an Ihrem Mac direkt in der Apple Book App lesen.

Sie lesen lieber im Amazon Kindle, dann schicken Sie die epub Datei per Mail an Ihren Kindle Reader.

Eine Bearbeitung mit Sigil oder ähnlichen Apps ist auch möglich oder prüfen Sie Ihr eBook mit der Kindle Previewer App.
