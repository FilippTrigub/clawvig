#!/usr/bin/env bash
# One-shot setup: install pycaps and browser dependencies
set -euo pipefail

echo "==> Installing pycaps..."
pip install "git+https://github.com/francozanardi/pycaps.git#egg=pycaps[all]"

echo "==> Installing Playwright Chromium (needed for CSS rendering)..."
playwright install chromium

echo "==> Setup complete. Run the service with:"
echo "    python caption_service.py --help"
