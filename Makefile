# # Variables
# PYTHON = python3
# VENV = venv
# PIP = $(VENV)/bin/pip
# PYTHON_VENV = $(VENV)/bin/python
# MANAGE = $(PYTHON_VENV) manage.py
# FLAKE8 = $(VENV)/bin/flake8
# BLACK = $(VENV)/bin/black
# NPM = npm

# # Default target
# .PHONY: help
# help:
# 	@echo "Available commands:"
# 	@echo "  make install    - Create virtual environment and install dependencies"
# 	@echo "  make run        - Run the development server"
# 	@echo "  make migrate    - Run database migrations"
# 	@echo "  make load-data  - Load initial data using load_data.py"
# 	@echo "  make test       - Run tests"
# 	@echo "  make clean      - Remove virtual environment and cache files"
# 	@echo "  make lint       - Run linting checks"
# 	@echo "  make format     - Format code using black"
# 	@echo "  make shell      - Open Django shell"
# 	@echo "  make superuser  - Create a superuser"

# # Create virtual environment and install dependencies
# .PHONY: install
# install:
# 	@echo "Creating virtual environment..."
# 	$(PYTHON) -m venv $(VENV)
# 	@echo "Installing dependencies..."
# 	$(PIP) install --upgrade pip
# 	$(PIP) install -r blawx/requirements.txt
# 	$(PIP) install -r blawx/requirements_dev.txt
# 	@echo "Installation complete!"


# # Create necessary directories
# .PHONY: create-dirs
# create-dirs:
# 	@echo "Creating necessary directories..."
# 	mkdir -p static/blawx
# 	mkdir -p static/blawx/blockly/appengine
# 	mkdir -p static/blawx/fonts
# 	mkdir -p staticfiles

# # Install npm dependencies
# # Install npm dependencies
# .PHONY: install-npm
# install-npm:
# 	@echo "Installing npm dependencies..."
# 	$(NPM) install blockly
# 	$(NPM) install jquery
# 	$(NPM) install bootstrap
# 	$(NPM) install bootstrap-icons


# # Download static files
# .PHONY: download-static
# download-static: create-dirs install-npm
# 	@echo "Downloading and moving static files..."
# 	# Blockly files
# 	cp -r node_modules/blockly/* static/blawx/blockly/
# 	curl https://raw.githubusercontent.com/google/blockly/develop/appengine/storage.js > static/blawx/blockly/appengine/storage.js
	
# 	# jQuery
# 	cp node_modules/jquery/dist/jquery.min.js static/blawx/jquery.min.js
	
# 	# Bootstrap
# 	cp node_modules/bootstrap/dist/css/bootstrap.min.css static/blawx/bootstrap.min.css
# 	cp node_modules/bootstrap/dist/css/bootstrap.min.css.map static/blawx/bootstrap.min.css.map
# 	cp node_modules/bootstrap/dist/js/bootstrap.bundle.min.js static/blawx/bootstrap.bundle.min.js
# 	cp node_modules/bootstrap/dist/js/bootstrap.bundle.min.js.map static/blawx/bootstrap.bundle.min.js.map
	
# 	# Bootstrap Icons
# 	cp node_modules/bootstrap-icons/font/bootstrap-icons.css static/blawx/bootstrap-icons.css
# 	cp node_modules/bootstrap-icons/font/fonts/bootstrap-icons.woff static/blawx/fonts/bootstrap-icons.woff
# 	cp node_modules/bootstrap-icons/font/fonts/bootstrap-icons.woff2 static/blawx/fonts/bootstrap-icons.woff2
	
# 	@echo "Creating fonts.css..."
# 	@echo '@font-face { font-family: "Mina"; src: url("https://fonts.googleapis.com/css2?family=Mina:wght@700&display=swap"); }' > static/blawx/fonts.css
# 	@echo '@font-face { font-family: "IBM Plex Sans"; src: url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@500&display=swap"); }' >> static/blawx/fonts.css
# 	chmod -R 755 static


# # Run the development server
# .PHONY: run
# run:
# 	@echo "Starting development server..."
# 	$(MANAGE) runserver 0.0.0.0:8000

# # Run database migrations
# .PHONY: migrate
# migrate:
# 	@echo "Running migrations..."
# 	$(MANAGE) makemigrations
# 	$(MANAGE) migrate --run-syncdb

# # Collect static files
# .PHONY: collectstatic
# collectstatic: download-static
# 	@echo "Collecting static files..."
# 	$(MANAGE) collectstatic --noinput

# # Load initial data using load_data.py
# .PHONY: load-data
# load-data: migrate
# 	@echo "Loading initial data using load_data.py..."
# 	$(PYTHON_VENV) load_data.py || true

# # Run tests
# .PHONY: test
# test:
# 	@echo "Running tests..."
# 	$(MANAGE) test

# # Clean up
# .PHONY: clean
# clean:
# 	@echo "Cleaning up..."
# 	rm -rf $(VENV)
# 	rm -rf staticfiles
# 	rm -f db.sqlite3
# 	find . -type d -name "__pycache__" -exec rm -r {} +
# 	find . -type f -name "*.pyc" -delete
# 	find . -type f -name "*.pyo" -delete
# 	find . -type f -name "*.pyd" -delete
# 	find . -type f -name ".coverage" -delete
# 	find . -type d -name "*.egg-info" -exec rm -r {} +
# 	find . -type d -name "*.egg" -exec rm -r {} +
# 	find . -type d -name ".pytest_cache" -exec rm -r {} +
# 	find . -type d -name ".coverage" -exec rm -r {} +
# 	find . -type d -name "htmlcov" -exec rm -r {} +

# # Run linting
# .PHONY: lint
# lint:
# 	@echo "Running linting checks..."
# 	$(FLAKE8) .
# 	$(BLACK) --check .

# # Format code
# .PHONY: format
# format:
# 	@echo "Formatting code..."
# 	$(BLACK) .

# # Open Django shell
# .PHONY: shell
# shell:
# 	@echo "Opening Django shell..."
# 	$(MANAGE) shell

# # Create superuser
# .PHONY: superuser
# superuser:
# 	@echo "Creating superuser..."
# 	$(MANAGE) createsuperuser

# # Setup development environment
# .PHONY: setup
# setup: install create-dirs install-npm download-static migrate load-data collectstatic
# 	@echo "Development environment setup complete!"

# # Run all checks
# .PHONY: check
# check: lint test
# 	@echo "All checks completed!"


# Variables
PYTHON         := python3
VENV           := venv
PIP            := $(if $(DEVCONTAINER),pip,$(VENV)/bin/pip)
PYTHON_VENV    := $(if $(DEVCONTAINER),python3,$(VENV)/bin/python)
MANAGE         := $(PYTHON_VENV) manage.py
FLAKE8         := $(if $(DEVCONTAINER),flake8,$(VENV)/bin/flake8)
BLACK          := $(if $(DEVCONTAINER),black,$(VENV)/bin/black)
NPM            := npm

# Paths
STATIC_DIR     := static
BLAWX_DIR      := $(STATIC_DIR)/blawx
BLAWX_BLOCKLY  := $(BLAWX_DIR)/blockly
BLAWX_APPENG   := $(BLAWX_BLOCKLY)/appengine
BLAWX_FONTS    := $(BLAWX_DIR)/fonts

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make install       - Create virtual environment & install Python dependencies"
	@echo "  make create-dirs   - Create necessary static directories"
	@echo "  make install-npm   - Install npm dependencies"
	@echo "  make download-static - Download/move static files into place"
	@echo "  make run           - Run the development server"
	@echo "  make migrate       - Run database migrations"
	@echo "  make load-data     - Load initial data"
	@echo "  make test          - Run tests"
	@echo "  make clean         - Remove venv/cache files"
	@echo "  make lint          - Run linting checks"
	@echo "  make format        - Format code using Black"
	@echo "  make shell         - Open Django shell"
	@echo "  make superuser     - Create a superuser"
	@echo "  make setup         - Setup dev environment (install, npm, static, migrate, data)"
	@echo "  make check         - Run linting and tests"

# Create virtual environment and install Python dependencies
.PHONY: install
install:
	@if [ -z "$$DEVCONTAINER" ]; then \
		echo "Creating virtual environment..."; \
		$(PYTHON) -m venv $(VENV); \
	fi
	@echo "Installing dependencies..."
	$(PIP) install --upgrade pip
	$(PIP) install -r blawx/requirements.txt
	$(PIP) install -r blawx/requirements_dev.txt
	@echo "Installation complete!"

# Create necessary directories for static files
.PHONY: create-dirs
create-dirs:
	@echo "Creating necessary directories..."
	mkdir -p $(BLAWX_DIR)
	mkdir -p $(BLAWX_APPENG)
	mkdir -p $(BLAWX_FONTS)
	mkdir -p staticfiles

# Install npm dependencies
.PHONY: install-npm
install-npm:
	@echo "Installing npm dependencies..."
	$(NPM) install blockly jquery bootstrap bootstrap-icons

# Download and organize static files
.PHONY: download-static
download-static: create-dirs install-npm
	@echo "Moving static files..."
	# Blockly files
	cp -r node_modules/blockly/* $(BLAWX_BLOCKLY)/
	curl https://raw.githubusercontent.com/google/blockly/develop/appengine/storage.js \
		> $(BLAWX_APPENG)/storage.js

	# jQuery
	cp node_modules/jquery/dist/jquery.min.js $(BLAWX_DIR)/jquery.min.js

	# Bootstrap
	cp node_modules/bootstrap/dist/css/bootstrap.min.css $(BLAWX_DIR)/bootstrap.min.css
	cp node_modules/bootstrap/dist/css/bootstrap.min.css.map $(BLAWX_DIR)/bootstrap.min.css.map
	cp node_modules/bootstrap/dist/js/bootstrap.bundle.min.js $(BLAWX_DIR)/bootstrap.bundle.min.js
	cp node_modules/bootstrap/dist/js/bootstrap.bundle.min.js.map $(BLAWX_DIR)/bootstrap.bundle.min.js.map

	# Bootstrap Icons
	cp node_modules/bootstrap-icons/font/bootstrap-icons.css $(BLAWX_DIR)/bootstrap-icons.css
	cp node_modules/bootstrap-icons/font/fonts/bootstrap-icons.woff $(BLAWX_FONTS)/bootstrap-icons.woff
	cp node_modules/bootstrap-icons/font/fonts/bootstrap-icons.woff2 $(BLAWX_FONTS)/bootstrap-icons.woff2

	@echo "Creating fonts.css..."
	@echo '@font-face { font-family: "Mina"; src: url("https://fonts.googleapis.com/css2?family=Mina:wght@700&display=swap"); }' > $(BLAWX_DIR)/fonts.css
	@echo '@font-face { font-family: "IBM Plex Sans"; src: url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@500&display=swap"); }' >> $(BLAWX_DIR)/fonts.css

	chmod -R 755 $(STATIC_DIR)

# Run the development server
.PHONY: run
run:
	@echo "Starting development server..."
	$(MANAGE) runserver 0.0.0.0:8000

# Migrate database
.PHONY: migrate
migrate:
	@echo "Running migrations..."
	$(MANAGE) makemigrations
	$(MANAGE) migrate --run-syncdb

# Collect static files
.PHONY: collectstatic
collectstatic: download-static
	@echo "Collecting static files..."
	$(MANAGE) collectstatic --noinput

# Load initial data
.PHONY: load-data
load-data: migrate
	@echo "Loading initial data..."
	$(PYTHON_VENV) load_data.py || true

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	$(MANAGE) test

# Clean up environment
.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -rf $(VENV) staticfiles db.sqlite3
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -r {} +
	find . -type d -name "*.egg" -exec rm -r {} +
	find . -type d -name ".pytest_cache" -exec rm -r {} +
	find . -type d -name ".coverage" -exec rm -r {} +
	find . -type d -name "htmlcov" -exec rm -r {} +
	@echo "Cleanup complete!"

# Linting
.PHONY: lint
lint:
	@echo "Running linting checks..."
	$(FLAKE8) .
	$(BLACK) --check .

# Format code
.PHONY: format
format:
	@echo "Formatting code..."
	$(BLACK) .

# Open Django shell
.PHONY: shell
shell:
	@echo "Opening Django shell..."
	$(MANAGE) shell

# Create superuser
.PHONY: superuser
superuser:
	@echo "Creating superuser..."
	$(MANAGE) createsuperuser

# Setup development environment
.PHONY: setup
setup: install create-dirs install-npm download-static migrate load-data collectstatic
	@echo "Development environment setup complete!"

# Run all checks (lint + test)
.PHONY: check
check: lint test
	@echo "All checks completed!"