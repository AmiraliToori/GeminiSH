# Makefile for GeminiSH

# Variables
SHELL := /bin/bash
SCRIPT_MAIN := GeminiSH.sh
SCRIPTS_LIB := $(wildcard lib/*.sh)
SCRIPTS_CONFIGS := $(wildcard configs/*.sh)
ALL_SCRIPTS := $(SCRIPT_MAIN) $(SCRIPTS_LIB) $(SCRIPTS_CONFIGS)

# Phony targets
.PHONY: all install run clean help

all: run

# Target to run the main script
run: $(SCRIPT_MAIN)
	@chmod +x $(ALL_SCRIPTS)
	@./$(SCRIPT_MAIN)

# Target to install dependencies
install:
	@chmod +x $(ALL_SCRIPTS)
	@echo "Attempting to install dependencies..."
	@if command -v apt-get > /dev/null; then \
		echo "Detected apt-get (Debian/Ubuntu)."; \
		sudo apt-get update && \
		sudo apt-get install -y curl jq glow gum xclip; \
	elif command -v brew > /dev/null; then \
		echo "Detected Homebrew (macOS)."; \
		brew install curl jq glow gum pbcopy; \
	else \
		echo "Could not detect apt-get or brew. Please install dependencies manually:"; \
		echo "curl, jq, glow, gum, and a clipboard utility (xclip for Linux, pbcopy for macOS)"; \
		exit 1; \
	fi
	@echo "Dependencies installation attempt finished."

# Target to make scripts executable (usually handled by install or run)
executable:
	@chmod +x $(ALL_SCRIPTS)
	@echo "Made scripts executable."

clean:
	@echo "Clean target - nothing to clean for now."

help:
	@echo "Available targets:"
	@echo "  all        - Default target, runs the script (same as 'run')."
	@echo "  run        - Runs the GeminiSH script."
	@echo "  install    - Installs required dependencies (curl, jq, glow, gum, xclip/pbcopy)."
	@echo "  executable - Makes all shell scripts executable."
	@echo "  clean      - Placeholder for cleanup tasks."
	@echo "  help       - Shows this help message."
