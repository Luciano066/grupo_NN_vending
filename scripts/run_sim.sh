#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

source /Tools/synopsys/snps.sh

mkdir -p sim

{
  vcs -full64 -sverilog -f files.f
  ./simv
} | tee sim/sim.log
