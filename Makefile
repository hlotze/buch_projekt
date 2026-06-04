# ============================================
#   Makefile für Buchprojekt
#   Automatisierung: Kapitel, Fragmente, Build
# ============================================

# --------------------------------------------
# Automatische Projekterkennung
# --------------------------------------------
# Finde den Ordner, der ein Kapitel-Verzeichnis enthält
PROJECT_DIR := $(firstword $(wildcard */Kapitel))
PROJECT_DIR := $(dir $(PROJECT_DIR))
PROJECT_DIR := $(patsubst %/,%,$(PROJECT_DIR))

# Falls kein Projekt gefunden wurde → Fehler
ifeq ($(PROJECT_DIR),)
$(error Kein Projektverzeichnis gefunden. Bitte zuerst create_book_project.sh ausführen.)
endif

KAPITEL_DIR := $(PROJECT_DIR)/Kapitel
FRAG_DIR    := $(PROJECT_DIR)/Fragmente

YQ      := yq
PANDOC  := pandoc

# --------------------------------------------
# Automatische Nummernfindung
# --------------------------------------------
NEXT_KAPITEL := $(shell n=$$(ls $(KAPITEL_DIR)/*_Kapitel.md 2>/dev/null | sed 's/.*\/\([0-9][0-9][0-9]\)_Kapitel.md/\1/' | sort -n | tail -1); [ -z "$$n" ] && n=0; printf "%03d" $$((n+10)))
NEXT_FRAGMENT := $(shell n=$$(ls $(FRAG_DIR)/*_Fragment.md 2>/dev/null | sed 's/.*\/\([0-9][0-9][0-9]\)_Fragment.md/\1/' | sort -n | tail -1); [ -z "$$n" ] && n=0; printf "%03d" $$((n+10)))

# --------------------------------------------
# HELP – automatisch generiert aus ## Kommentaren
# --------------------------------------------
help: ## Zeigt diese Hilfe an
	@echo ""
	@echo "📘 Verfügbare Makefile-Befehle:"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?##' Makefile \
		| sed -e 's/:.*##/:  /' \
		| awk 'BEGIN {FS="  "} {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

# --------------------------------------------
# Kapitel & Fragmente
# --------------------------------------------
new-kapitel: ## Neues Kapitel anlegen
	@echo "📄 Erzeuge Kapitel $(NEXT_KAPITEL)_Kapitel.md"
	cp $(KAPITEL_DIR)/000_Kapitel_template.md $(KAPITEL_DIR)/$(NEXT_KAPITEL)_Kapitel.md
	@$(YQ) -i '.nummer = $(NEXT_KAPITEL) | .titel = "Kapitel $(NEXT_KAPITEL)"' $(KAPITEL_DIR)/$(NEXT_KAPITEL)_Kapitel.md
	@echo "✔️ Kapitel erstellt: $(KAPITEL_DIR)/$(NEXT_KAPITEL)_Kapitel.md"

new-fragment: ## Neues Fragment anlegen
	@echo "🧩 Erzeuge Fragment $(NEXT_FRAGMENT)_Fragment.md"
	cp $(FRAG_DIR)/000_Fragment_template.md $(FRAG_DIR)/$(NEXT_FRAGMENT)_Fragment.md
	@$(YQ) -i '.nummer = $(NEXT_FRAGMENT) | .titel = "Fragment $(NEXT_FRAGMENT)"' $(FRAG_DIR)/$(NEXT_FRAGMENT)_Fragment.md
	@echo "✔️ Fragment erstellt: $(FRAG_DIR)/$(NEXT_FRAGMENT)_Fragment.md"

# --------------------------------------------
# Analyse & Qualität
# --------------------------------------------
stats: ## Wortstatistik anzeigen
	@echo "📊 Wortstatistik:"
	@find $(PROJECT_DIR) -name '*.md' -print0 | xargs -0 wc -w

check: ## Prüft auf fehlende '# Titel'-Zeilen
	@echo "🔍 Prüfe auf fehlende '# Titel'-Zeilen..."
	@missing=$$(grep -L '^# Titel' $$(find $(PROJECT_DIR) -name '*.md') || true); \
	if [ -n "$$missing" ]; then \
		echo "$$missing" | sed 's/^/Fehlender Titel: /'; \
	else \
		echo "✔️ Alle Dateien haben einen '# Titel'"; \
	fi

# --------------------------------------------
# Backup
# --------------------------------------------
backup: ## Erstellt ein ZIP-Backup des Projekts
	@echo "💾 Erstelle Backup..."
	@mkdir -p backups
	@zip -qr backups/buchprojekt_$$(date +%Y-%m-%d_%H-%M).zip $(PROJECT_DIR)
	@echo "✔️ Backup erstellt"

# --------------------------------------------
# Build (Pandoc)
# --------------------------------------------
build: pdf epub docx ## Baut alle Ausgabeformate

pdf: ## Erzeugt PDF mit Pandoc
	@mkdir -p build
	@echo "📚 Erzeuge PDF..."
	@$(PANDOC) $(KAPITEL_DIR)/*_Kapitel.md -o build/buch.pdf --toc --toc-depth=3
	@echo "✔️ PDF: build/buch.pdf"

epub: ## Erzeugt EPUB mit Pandoc
	@mkdir -p build
	@echo "📚 Erzeuge EPUB..."
	@$(PANDOC) $(KAPITEL_DIR)/*_Kapitel.md -o build/buch.epub --toc --toc-depth=3
	@echo "✔️ EPUB: build/buch.epub"

docx: ## Erzeugt DOCX mit Pandoc
	@mkdir -p build
	@echo "📚 Erzeuge DOCX..."
	@$(PANDOC) $(KAPITEL_DIR)/*_Kapitel.md -o build/buch.docx --toc --toc-depth=3
	@echo "✔️ DOCX: build/buch.docx"

# --------------------------------------------
# Kapitelindex
# --------------------------------------------
index: ## Erzeugt Kapitelindex aus YAML
	@echo "📑 Erzeuge Kapitelindex..."
	@out="$(KAPITEL_DIR)/index.md"; \
	echo "# Kapitelindex" > $$out; \
	for f in $(KAPITEL_DIR)/*_Kapitel.md; do \
		[ "$$f" = "$$out" ] && continue; \
		num=$$($(YQ) '.nummer' $$f); \
		title=$$($(YQ) '.titel' $$f); \
		status=$$($(YQ) '.status' $$f); \
		word=$$($(YQ) '.wortziel' $$f); \
		echo "- Kapitel $$num: $$title (Status: $$status, Ziel: $$word Wörter)" >> $$out; \
	done
	@echo "✔️ Kapitelindex aktualisiert: $(KAPITEL_DIR)/index.md"
