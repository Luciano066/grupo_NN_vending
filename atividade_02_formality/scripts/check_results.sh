#!/usr/bin/env bash
# Resume os resultados reais produzidos pelo Formality para as duas variantes.
# Este script apenas lê logs e relatórios existentes; ele não executa ferramentas.
set -uo pipefail

# Resolve a raiz da atividade para permitir a chamada a partir de qualquer pasta.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

GROUPED_LOG="$ROOT_DIR/fm/logs/formality_grouped.log"
UNGROUPED_LOG="$ROOT_DIR/fm/logs/formality_ungrouped.log"

# Sem os dois logs não existe evidência local suficiente para conferir o status.
missing_logs=0
for log_file in "$GROUPED_LOG" "$UNGROUPED_LOG"; do
  if [[ ! -s "$log_file" ]]; then
    printf 'ERRO: log necessário ausente ou vazio: %s\n' "$log_file" >&2
    missing_logs=1
  fi
done

if (( missing_logs != 0 )); then
  printf '%s\n' \
    'Gere primeiro os resultados no ambiente Linux com as ferramentas Synopsys; este script não executa o Formality.' >&2
  exit 2
fi

overall_status=0

# Verification SUCCEEDED no log é o critério principal de sucesso de cada fluxo.
show_verification_status() {
  local variant="$1"
  local log_file="$2"

  if grep -Fq 'Verification SUCCEEDED' "$log_file"; then
    printf '[OK] %s: Verification SUCCEEDED\n' "$variant"
  else
    printf '[FALHA] %s: Verification SUCCEEDED não foi encontrado em %s\n' \
      "$variant" "$log_file"
    overall_status=1
  fi
}

# Exibe as linhas relevantes dos relatórios finais de failing e unmatched points.
# A ausência de um relatório é sinalizada, mas os logs continuam sendo avaliados.
show_point_report() {
  local variant="$1"
  local point_kind="$2"
  local report_file="$3"

  printf '\n%s — %s (%s)\n' "$variant" "$point_kind" "$report_file"
  if [[ ! -s "$report_file" ]]; then
    printf 'AVISO: relatório final ausente ou vazio; gere-o no ambiente Synopsys.\n'
    return
  fi

  if ! grep -Ein 'fail|unmatched|compare[[:space:]]+point|matched[[:space:]]+point' "$report_file"; then
    printf 'Nenhuma linha de resumo com failing/unmatched points foi encontrada.\n'
  fi
}

show_verification_status 'grouped' "$GROUPED_LOG"
show_verification_status 'ungrouped' "$UNGROUPED_LOG"

show_point_report \
  'grouped' 'failing points' \
  "$ROOT_DIR/fm/reports/grouped/failing_points.rpt"
show_point_report \
  'grouped' 'unmatched points' \
  "$ROOT_DIR/fm/reports/grouped/unmatched_points_final.rpt"
show_point_report \
  'ungrouped' 'failing points' \
  "$ROOT_DIR/fm/reports/ungrouped/failing_points.rpt"
show_point_report \
  'ungrouped' 'unmatched points' \
  "$ROOT_DIR/fm/reports/ungrouped/unmatched_points_final.rpt"

exit "$overall_status"
