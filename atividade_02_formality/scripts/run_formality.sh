#!/usr/bin/env bash
# Executa, em sequência, as verificações grouped e ungrouped no servidor Linux.
set -euo pipefail

# Localiza a raiz da atividade sem depender do diretório de chamada.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Carrega ferramentas/licenças e entra em fm/, como esperado pelos caminhos Tcl.
source /Tools/synopsys/snps.sh

cd "$ROOT_DIR/fm"
mkdir -p logs reports/grouped reports/ungrouped

# Cada execução grava no terminal e no log correspondente. As sínteses devem ter
# sido concluídas antes, pois os scripts consomem suas netlists e seus SVFs.
fm_shell -f formality_grouped.tcl 2>&1 | tee logs/formality_grouped.log
fm_shell -f formality_ungrouped.tcl 2>&1 | tee logs/formality_ungrouped.log
