#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source /Tools/synopsys/snps.sh

cd "$ROOT_DIR/fm"
mkdir -p logs reports/grouped reports/ungrouped

fm_shell -f formality_grouped.tcl 2>&1 | tee logs/formality_grouped.log
fm_shell -f formality_ungrouped.tcl 2>&1 | tee logs/formality_ungrouped.log
