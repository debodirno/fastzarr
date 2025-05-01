# Makefile for easy development workflows.
# See development.md for docs.
# Note GitHub Actions call uv directly, not this Makefile.

.DEFAULT_GOAL := default

.PHONY: build clean default install lint test upgrade

default: install lint test

install:
	uv sync --all-extras --dev

lint:
	uv run python devtools/lint.py

	@echo "Adding trailing newlines to all files, if needed..."
	@git ls-files -z | xargs -0 -I {} sh -c 'if file "{}" | grep -q "text"; then perl -pi -e "s/(?<!\\n)\\z/\\n/" "{}"; fi'

test:
	uv run pytest

upgrade:
	uv sync --upgrade

build:
	uv build

clean:
	-rm -rf dist/
	-rm -rf *.egg-info/
	-rm -rf .pytest_cache/
	-rm -rf .mypy_cache/
	-rm -rf .venv/
	-find . -type d -name "__pycache__" -exec rm -rf {} +
