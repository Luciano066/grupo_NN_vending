#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

source /Tools/synopsys/snps.sh

LIB_SRC="/home/luciano.oliveira/acumulador-oficial/libs/saed32rvt_tt1p05v25c.db"
LIB_DST="libs/saed32rvt_tt1p05v25c.db"
SDC_FILE="synth/vending.sdc"
PERIODS=(20 18 16 14 12 10 8 6 5 4)

mkdir -p libs synth/reports synth/netlist
ln -sfn "$LIB_SRC" "$LIB_DST"

ORIGINAL_SDC="$(mktemp)"
cp "$SDC_FILE" "$ORIGINAL_SDC"

cleanup() {
  cp "$ORIGINAL_SDC" "$SDC_FILE"
  rm -f "$ORIGINAL_SDC"
}
trap cleanup EXIT

printf "%-10s %-12s %-10s %-14s\n" "Periodo" "Freq(MHz)" "Slack(ns)" "Area"

for period in "${PERIODS[@]}"; do
  perl -0pi -e "s/create_clock -name clk -period [0-9.]+/create_clock -name clk -period ${period}.0/" "$SDC_FILE"

  dc_shell -f synth/synth.tcl > "synth/synth_${period}ns.log" 2>&1

  cp synth/reports/area.rpt "synth/reports/area_${period}ns.rpt"
  cp synth/reports/timing.rpt "synth/reports/timing_${period}ns.rpt"

  slack="$(awk '/slack \((MET|VIOLATED)\)/ {print $NF; exit}' "synth/reports/timing_${period}ns.rpt")"
  area="$(awk '/Total cell area:/ {print $4; exit}' "synth/reports/area_${period}ns.rpt")"
  freq="$(awk -v period="$period" 'BEGIN {printf "%.2f", 1000 / period}')"

  printf "%-10s %-12s %-10s %-14s\n" "${period}ns" "$freq" "${slack:-NA}" "${area:-NA}"
done
