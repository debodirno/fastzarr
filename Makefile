# Makefile for easy development workflows.
# See development.md for docs.
# Note GitHub Actions call uv directly, not this Makefile.

.DEFAULT_GOAL := default

.PHONY: add-trailing-newline build clean default install lint test upgrade

default: add-trailing-newline install lint test

install:
	uv sync --all-extras --dev

add-trailing-newline:
	@git ls-files -z | xargs -0 -I {} sh -c 'if file "{}" | grep -q "text"; then perl -pi -e "s/(?<!\\n)\\z/\\n/" "{}"; fi'

lint:
	uv run python devtools/lint.py

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
