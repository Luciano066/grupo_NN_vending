#!/usr/bin/env bash
# Gera as implementações grouped e ungrouped usadas na equivalência formal.
set -euo pipefail

# Determina a raiz da atividade a partir do caminho deste arquivo.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Inicializa ferramentas/licenças e entra em synth/, requisito dos scripts Tcl.
source /Tools/synopsys/snps.sh

cd "$ROOT_DIR/synth"
mkdir -p logs

# A primeira compilação preserva hierarquia; a segunda permite autoungroup.
# stdout e stderr de cada Design Compiler são registrados em arquivos separados.
dc_shell -f synth_grouped.tcl 2>&1 | tee logs/synth_grouped.log
dc_shell -f synth_ungrouped.tcl 2>&1 | tee logs/synth_ungrouped.log
