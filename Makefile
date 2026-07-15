.PHONY: run run-cli clean setup help

VENV = .venv
PYTHON = $(VENV)/bin/python
OPENFILTER = $(VENV)/bin/openfilter

help:
	@echo "🎥 OpenFilters Webvis POC Makefile"
	@echo "=================================="
	@echo "Available commands:"
	@echo "  make run        - Run the pipeline programmatically using Python script (Recommended)"
	@echo "  make run-cli    - Run the pipeline using the openfilter CLI"
	@echo "  make setup      - (Re)create virtual env and install all requirements"
	@echo "  make clean      - Clean up virtual environment and logs"

run:
	@echo "🚀 Launching OpenFilters Pipeline programmatically..."
	@echo "Point your browser to http://localhost:8000 once running."
	$(PYTHON) run_pipeline.py

run-cli:
	@echo "🚀 Launching OpenFilters Pipeline via CLI..."
	@echo "Point your browser to http://localhost:8000 once running."
	$(OPENFILTER) run \
	  - VideoIn \
	    --sources "file://$(shell pwd)/data/combined_video.mp4!loop!sync" \
	    --outputs "tcp://*:5550" \
	  - Webvis \
	    --sources "tcp://localhost:5550" \
	    --port 8000

setup:
	@echo "🛠️ Creating Python 3.13 virtual environment..."
	rm -rf $(VENV)
	python3.13 -m venv $(VENV)
	@echo "📥 Installing dependencies (editable openfilter with video-in and webvis extra)..."
	$(VENV)/bin/pip install --upgrade pip
	$(VENV)/bin/pip install -e "/Users/lintly/git/Plainsight/Application/openfilter[video-in,webvis]" opencv-python

clean:
	@echo "🧹 Cleaning up workspace..."
	rm -rf $(VENV)
	find . -type d -name "__pycache__" -exec rm -rf {} +
