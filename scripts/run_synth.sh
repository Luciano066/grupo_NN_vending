#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

source /Tools/synopsys/snps.sh

mkdir -p libs synth/reports synth/netlist
ln -sfn /home/luciano.oliveira/acumulador-oficial/libs/saed32rvt_tt1p05v25c.db \
  libs/saed32rvt_tt1p05v25c.db

dc_shell -f synth/synth.tcl | tee synth/synth.log
