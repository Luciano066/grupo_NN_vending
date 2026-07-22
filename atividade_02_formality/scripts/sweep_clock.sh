#!/usr/bin/env bash
# Explora diferentes períodos de clock com o fluxo legado de síntese.
set -euo pipefail

# Resolve a raiz da atividade para permitir a chamada a partir de qualquer pasta.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Inicializa no servidor Linux o ambiente licenciado das ferramentas.
source /Tools/synopsys/snps.sh

# Origem/destino da biblioteca, SDC editado temporariamente e períodos avaliados.
LIB_SRC="/home/luciano.oliveira/acumulador-oficial/libs/saed32rvt_tt1p05v25c.db"
LIB_DST="libs/saed32rvt_tt1p05v25c.db"
SDC_FILE="synth/vending.sdc"
PERIODS=(20 18 16 14 12 10 8 6 5 4)

mkdir -p libs synth/reports synth/netlist
ln -sfn "$LIB_SRC" "$LIB_DST"

# Salva uma cópia temporária do SDC original antes de alterar seu create_clock.
ORIGINAL_SDC="$(mktemp)"
cp "$SDC_FILE" "$ORIGINAL_SDC"

cleanup() {
  cp "$ORIGINAL_SDC" "$SDC_FILE"
  rm -f "$ORIGINAL_SDC"
}
# Restaura o SDC mesmo se a execução for interrompida ou alguma síntese falhar.
trap cleanup EXIT

# Cabeçalho da tabela resumida enviada à saída padrão.
printf "%-10s %-12s %-10s %-14s\n" "Periodo" "Freq(MHz)" "Slack(ns)" "Area"

for period in "${PERIODS[@]}"; do
  # Ajusta somente o período, sintetiza e arquiva os relatórios desta rodada.
  perl -0pi -e "s/create_clock -name clk -period [0-9.]+/create_clock -name clk -period ${period}.0/" "$SDC_FILE"

  dc_shell -f synth/synth.tcl > "synth/synth_${period}ns.log" 2>&1

  cp synth/reports/area.rpt "synth/reports/area_${period}ns.rpt"
  cp synth/reports/timing.rpt "synth/reports/timing_${period}ns.rpt"

  # Extrai slack/área dos relatórios e calcula a frequência em MHz (1000/ns).
  slack="$(awk '/slack \((MET|VIOLATED)\)/ {print $NF; exit}' "synth/reports/timing_${period}ns.rpt")"
  area="$(awk '/Total cell area:/ {print $4; exit}' "synth/reports/area_${period}ns.rpt")"
  freq="$(awk -v period="$period" 'BEGIN {printf "%.2f", 1000 / period}')"

  printf "%-10s %-12s %-10s %-14s\n" "${period}ns" "$freq" "${slack:-NA}" "${area:-NA}"
done
