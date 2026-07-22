#!/usr/bin/env bash
# Executa compilação e simulação funcional a partir de qualquer diretório.
# Falha no primeiro erro (-e), em variável indefinida (-u) ou em um pipeline (-o pipefail).
set -euo pipefail

# Resolve a raiz da atividade com base na localização deste script.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Carrega no Linux do laboratório as variáveis e licenças do ambiente Synopsys.
source /Tools/synopsys/snps.sh

# Garante o diretório de saída. O bloco compila a lista files.f, executa o
# simulador gerado e preserva a saída simultaneamente no terminal e em sim.log.
mkdir -p sim

{
  vcs -full64 -sverilog -f files.f
  ./simv
} | tee sim/sim.log
