#!/usr/bin/env bash
# Fluxo legado de síntese única, baseado em synth/synth.tcl.
# Para as variantes da equivalência formal, use run_synth_formality.sh.
set -euo pipefail

# Localiza a raiz da atividade e torna relativos a ela todos os caminhos abaixo.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Configuração de ferramentas e licenças no servidor Linux.
source /Tools/synopsys/snps.sh

# Prepara saídas e cria apenas um link local para a biblioteca tecnológica;
# o arquivo .db original não é copiado nem deve ser adicionado ao Git.
mkdir -p libs synth/reports synth/netlist
ln -sfn /home/luciano.oliveira/acumulador-oficial/libs/saed32rvt_tt1p05v25c.db \
  libs/saed32rvt_tt1p05v25c.db

# Executa o Design Compiler e grava a mesma saída em synth/synth.log.
dc_shell -f synth/synth.tcl | tee synth/synth.log
