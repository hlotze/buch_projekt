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
# - Kapitel, Fragmente
# --------------------------------------------
KAPITEL_FILES := $(wildcard $(KAPITEL_DIR)/[0-9][0-9][0-9]_Kapitel.md)
LAST_KAPITEL := $(notdir $(lastword $(sort $(KAPITEL_FILES))))
LAST_KAPITEL_NUM := $(firstword $(subst _, ,$(LAST_KAPITEL)))
NEXT_KAPITEL := $(shell printf '%03d' $$(expr $(if $(LAST_KAPITEL_NUM),$(LAST_KAPITEL_NUM),0) + 10))


FRAGMENT_FILES := $(wildcard $(FRAG_DIR)/[0-9][0-9][0-9]_Fragment.md)
LAST_FRAGMENT := $(notdir $(lastword $(sort $(FRAGMENT_FILES))))
LAST_FRAGMENT_NUM := $(firstword $(subst _, ,$(LAST_FRAGMENT)))
NEXT_FRAGMENT := $(shell printf '%03d' $$(expr $(if $(LAST_FRAGMENT_NUM),$(LAST_FRAGMENT_NUM),0) + 10))

# --------------------------------------------
# Automatische Nummernfindung
# - Plots, Themen, Welt
# --------------------------------------------
PLOT_DIR := $(PROJECT_DIR)/Plot
THEMEN_DIR := $(PROJECT_DIR)/Themen
WELT_DIR := $(PROJECT_DIR)/Welt

PLOT_FILES := $(wildcard $(PLOT_DIR)/[0-9][0-9][0-9]_*.md)
LAST_PLOT := $(notdir $(lastword $(sort $(PLOT_FILES))))
LAST_PLOT_NUM := $(firstword $(subst _, ,$(LAST_PLOT)))
NEXT_PLOT := $(shell printf '%03d' $$(expr $(if $(LAST_PLOT_NUM),$(LAST_PLOT_NUM),0) + 10))

THEMEN_FILES := $(wildcard $(THEMEN_DIR)/[0-9][0-9][0-9]_*.md)
LAST_THEMA := $(notdir $(lastword $(sort $(THEMEN_FILES))))
LAST_THEMA_NUM := $(firstword $(subst _, ,$(LAST_THEMA)))
NEXT_THEMA := $(shell printf '%03d' $$(expr $(if $(LAST_THEMA_NUM),$(LAST_THEMA_NUM),0) + 10))

WELT_FILES := $(wildcard $(WELT_DIR)/[0-9][0-9][0-9]_*.md)
LAST_WELT := $(notdir $(lastword $(sort $(WELT_FILES))))
LAST_WELT_NUM := $(firstword $(subst _, ,$(LAST_WELT)))
NEXT_WELT := $(shell printf '%03d' $$(expr $(if $(LAST_WELT_NUM),$(LAST_WELT_NUM),0) + 10))

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
	@$(YQ) eval --front-matter=process -i '.nummer = "$(NEXT_KAPITEL)" | .titel = "Kapitel $(NEXT_KAPITEL)"' $(KAPITEL_DIR)/$(NEXT_KAPITEL)_Kapitel.md
	@echo "✔️ Kapitel erstellt: $(KAPITEL_DIR)/$(NEXT_KAPITEL)_Kapitel.md"


new-fragment: ## Neues Fragment anlegen
	@echo "🧩 Erzeuge Fragment $(NEXT_FRAGMENT)_Fragment.md"
	cp $(FRAG_DIR)/000_Fragment_template.md $(FRAG_DIR)/$(NEXT_FRAGMENT)_Fragment.md
	@$(YQ) eval --front-matter=process -i '.nummer = "$(NEXT_FRAGMENT)" | .titel = "Fragment $(NEXT_FRAGMENT)"' $(FRAG_DIR)/$(NEXT_FRAGMENT)_Fragment.md
	@echo "✔️ Fragment erstellt: $(FRAG_DIR)/$(NEXT_FRAGMENT)_Fragment.md"

new-plot: ## Neuen Plot anlegen
	@echo "📦 Erzeuge Plot $(NEXT_PLOT)_Plot.md"
	cp $(PLOT_DIR)/000_Plot_template.md $(PLOT_DIR)/$(NEXT_PLOT)_Plot.md
	@$(YQ) eval --front-matter=process -i '.nummer = "$(NEXT_PLOT)" | .titel = "Plot $(NEXT_PLOT)"' $(PLOT_DIR)/$(NEXT_PLOT)_Plot.md
	@echo "✔️ Plot erstellt: $(PLOT_DIR)/$(NEXT_PLOT)_Plot.md"

new-thema: ## Neues Thema anlegen
	@echo "📝 Erzeuge Thema $(NEXT_THEMA)_Thema.md"
	cp $(THEMEN_DIR)/000_Themen_template.md $(THEMEN_DIR)/$(NEXT_THEMA)_Thema.md
	@$(YQ) eval --front-matter=process -i '.nummer = "$(NEXT_THEMA)" | .titel = "Thema $(NEXT_THEMA)"' $(THEMEN_DIR)/$(NEXT_THEMA)_Thema.md
	@echo "✔️ Thema erstellt: $(THEMEN_DIR)/$(NEXT_THEMA)_Thema.md"

new-welt: ## Neuen Welteintrag anlegen
	@echo "🌍 Erzeuge Welt $(NEXT_WELT)_Welt.md"
	cp $(WELT_DIR)/000_Welt_template.md $(WELT_DIR)/$(NEXT_WELT)_Welt.md
	@$(YQ) eval --front-matter=process -i '.nummer = "$(NEXT_WELT)" | .titel = "Welt $(NEXT_WELT)"' $(WELT_DIR)/$(NEXT_WELT)_Welt.md
	@echo "✔️ Welteintrag erstellt: $(WELT_DIR)/$(NEXT_WELT)_Welt.md"

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

debug: ## Zeigt erkannte Pfade und Nummern
	@echo "PROJECT_DIR=$(PROJECT_DIR)"
	@echo "KAPITEL_DIR=$(KAPITEL_DIR)"
	@echo "FRAG_DIR=$(FRAG_DIR)"
	@echo "NEXT_KAPITEL=$(NEXT_KAPITEL)"
	@echo "NEXT_FRAGMENT=$(NEXT_FRAGMENT)"
	@echo "NEXT_PLOT=$(NEXT_PLOT)"
	@echo "NEXT_THEMA=$(NEXT_THEMA)"
	@echo "NEXT_WELT=$(NEXT_WELT)"

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
