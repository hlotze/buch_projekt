#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="${1:-buchprojekt}"

echo "📚 Erstelle erweitertes Buchprojekt in: $PROJECT_DIR"
mkdir -p "$PROJECT_DIR"

# --------------------------------------------
# Hauptdateien
# --------------------------------------------
MAIN_FILES=(
  "010_Ideen.md"
  "020_Timeline.md"
  "030_Figuren.md"
  "040_Lore.md"
)

# --------------------------------------------
# Unterverzeichnisse
# --------------------------------------------
FRAG_DIR="$PROJECT_DIR/Fragmente"
KAP_DIR="$PROJECT_DIR/Kapitel"
PLOT_DIR="$PROJECT_DIR/Plot"
WELT_DIR="$PROJECT_DIR/Welt"
RECH_DIR="$PROJECT_DIR/Recherche"
THEM_DIR="$PROJECT_DIR/Themen"

# --------------------------------------------
# Dateien in Unterverzeichnissen
# --------------------------------------------
FRAG_FILES=(
  "000_Fragment_template.md"
  "010_Fragment.md"
  "020_Fragment.md"
)

KAP_FILES=(
  "000_Kapitel_template.md"
  "010_Kapitel.md"
  "020_Kapitel.md"
)

PLOT_FILES=(
  "000_Plot_template.md"
  "010_Plotstruktur.md"
  "020_Konflikte.md"
)

WELT_FILES=(
  "000_Welt_template.md"
  "010_Orte.md"
  "020_Kulturen.md"
)

RECH_FILES=(
  "000_Recherche_template.md"
  "010_Quellen.md"
)

THEM_FILES=(
  "000_Themen_template.md"
  "010_Motive.md"
)

# --------------------------------------------
# README‑Texte für Unterverzeichnisse
# --------------------------------------------
write_dir_readme() {
  local path="$1"
  local text="$2"

  cat > "$path/README.md" <<EOF
# Ordner: $(basename "$path")

$text
EOF
}

README_FRAG="In diesem Ordner werden alle Fragmente gesammelt. Fragmente sind unfertige Szenen, Ideen oder Textstücke, die später in Kapitel überführt werden können. Sie dienen als kreativer Spielplatz für spontane Einfälle."
README_KAP="In diesem Ordner liegen alle Kapitel des Buches. Jedes Kapitel besitzt eine YAML-Frontmatter und wird automatisch nummeriert. Hier entsteht der eigentliche Fließtext der Geschichte."
README_PLOT="Dieser Ordner enthält alle Plot-bezogenen Dokumente. Hier werden Struktur, Beats, Wendepunkte und Konflikte der Geschichte ausgearbeitet und gepflegt."
README_WELT="In diesem Ordner wird die Welt des Buches dokumentiert. Dazu gehören Orte, Kulturen, Regeln, Geschichte und alle Elemente des Worldbuildings."
README_RECH="Dieser Ordner enthält Recherchematerial. Hier werden Quellen, Fakten, Notizen und externe Informationen gesammelt, die für das Buch wichtig sind."
README_THEM="In diesem Ordner werden Themen, Motive und Symboliken dokumentiert. Hier wird festgehalten, welche übergeordneten Ideen die Geschichte tragen."

# --------------------------------------------
# Template‑Writer
# --------------------------------------------
write_main_file() {
  local path="$1"
  cat > "$path" << 'EOF'
# Titel
EOF
}

write_kapitel_template() {
  local path="$1"
  cat > "$path" << 'EOF'
---
type: "Kapitel"
nummer: 0
titel: ""
status: "draft"
perspektive: ""
figur: ""
ort: ""
datum_in_story: ""
tags: []
wortziel: 1500
---
# Titel
EOF
}

write_fragment_template() {
  local path="$1"
  cat > "$path" << 'EOF'
---
type: "Fragment"
nummer: 0
titel: ""
beschreibung: ""
reifegrad: "roh"
tags: []
---
# Titel
EOF
}

write_figuren_template() {
  local path="$1"
  cat > "$path" << 'EOF'
---
type: "Figur"
name: ""
rolle: ""
alter: ""
geschlecht: ""
beruf: ""
persoenlichkeit: ""
ziel: ""
konflikt_innerer: ""
konflikt_aeusserer: ""
beziehungen: []
tags: []
---
# Titel
EOF
}

write_welt_template() {
  local path="$1"
  cat > "$path" << 'EOF'
---
type: "Ort"
name: ""
kategorie: ""
beschreibung: ""
geschichte: ""
kultur: ""
klima: ""
relevante_figuren: []
tags: []
---
# Titel
EOF
}

write_plot_template() {
  local path="$1"
  cat > "$path" << 'EOF'
---
type: "Plot"
titel: ""
beat_typ: ""
kapitel: []
konflikt: ""
ziel_der_szene: ""
spannung: ""
tags: []
---
# Titel
EOF
}

write_recherche_template() {
  local path="$1"
  cat > "$path" << 'EOF'
---
type: "Recherche"
titel: ""
quelle: ""
autor: ""
jahr: ""
url: ""
relevanz: ""
notizen: ""
tags: []
---
# Titel
EOF
}

write_themen_template() {
  local path="$1"
  cat > "$path" << 'EOF'
---
type: "Thema"
titel: ""
beschreibung: ""
motiv: ""
symbolik: ""
wiederkehrend_in_kapiteln: []
tags: []
---
# Titel
EOF
}

# --------------------------------------------
# Ordner anlegen + README erzeugen
# --------------------------------------------
mkdir -p "$FRAG_DIR" "$KAP_DIR" "$PLOT_DIR" "$WELT_DIR" "$RECH_DIR" "$THEM_DIR"

write_dir_readme "$FRAG_DIR" "$README_FRAG"
write_dir_readme "$KAP_DIR" "$README_KAP"
write_dir_readme "$PLOT_DIR" "$README_PLOT"
write_dir_readme "$WELT_DIR" "$README_WELT"
write_dir_readme "$RECH_DIR" "$README_RECH"
write_dir_readme "$THEM_DIR" "$README_THEM"

# --------------------------------------------
# Hauptdateien
# --------------------------------------------
for f in "${MAIN_FILES[@]}"; do
  write_main_file "$PROJECT_DIR/$f"
done

# Figuren-Datei bekommt Figuren-YAML
write_figuren_template "$PROJECT_DIR/030_Figuren.md"

# --------------------------------------------
# Fragmente
# --------------------------------------------
for f in "${FRAG_FILES[@]}"; do
  write_fragment_template "$FRAG_DIR/$f"
done

# --------------------------------------------
# Kapitel
# --------------------------------------------
for f in "${KAP_FILES[@]}"; do
  write_kapitel_template "$KAP_DIR/$f"
done

# --------------------------------------------
# Plot
# --------------------------------------------
for f in "${PLOT_FILES[@]}"; do
  write_plot_template "$PLOT_DIR/$f"
done

# --------------------------------------------
# Welt
# --------------------------------------------
for f in "${WELT_FILES[@]}"; do
  write_welt_template "$WELT_DIR/$f"
done

# --------------------------------------------
# Recherche
# --------------------------------------------
for f in "${RECH_FILES[@]}"; do
  write_recherche_template "$RECH_DIR/$f"
done

# --------------------------------------------
# Themen
# --------------------------------------------
for f in "${THEM_FILES[@]}"; do
  write_themen_template "$THEM_DIR/$f"
done

echo "✅ Buchprojekt-Struktur mit YAML-Templates und README-Dateien erstellt in: $PROJECT_DIR"
