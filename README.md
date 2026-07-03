\# Controlador de Vending Machine em SystemVerilog



Projeto desenvolvido para a atividade avaliativa de RTL Design — Controlador Digital de uma Vending Machine em SystemVerilog.



Repositório:



```text

https://github.com/luciano066/grupo\_NN\_vending


Estrutura do projeto

grupo_NN_vending/
├── rtl/
│   ├── vending_pkg.sv
│   ├── credit_reg.sv
│   ├── memory.sv
│   ├── comparator.sv
│   ├── subtractor.sv
│   ├── control_unit.sv
│   └── vending_top.sv
├── sim/
│   ├── tb_vending.sv
│   └── sim.log
├── synth/
│   ├── synth.tcl
│   ├── vending.sdc
│   ├── reports/
│   └── netlist/
└── relatorio.pdf

mkdir -p libs
ln -sf /home/luciano.oliveira/acumulador-oficial/libs/saed32rvt_tt1p05v25c.db libs/saed32rvt_tt1p05v25c.db

