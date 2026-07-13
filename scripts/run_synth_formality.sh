#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source /Tools/synopsys/snps.sh

cd "$ROOT_DIR/synth"
mkdir -p logs

dc_shell -f synth_grouped.tcl 2>&1 | tee logs/synth_grouped.log
dc_shell -f synth_ungrouped.tcl 2>&1 | tee logs/synth_ungrouped.log
