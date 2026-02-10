# ============================================================
# Makefile - 04-run-phase
# 支持: VCS, Xcelium, Questa
# ============================================================

SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

# 源文件
SRC = examples/*.sv

# 输出
TOP = tb_phases
WAVE = dump.vcd

.PHONY: all compile run clean help

all: compile run

compile:
	@echo "========================================"
	@echo "  Compiling: 04-run-phase"
	@echo "  Simulator: $(SIM)"
	@echo "========================================"
ifeq ($(SIM),vcs)
	vcs -sverilog -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) \
		$(UVM_HOME)/src/uvm.sv \
		$(SRC) \
		-o $(TOP) \
		-l compile.log
else ifeq ($(SIM),xrun)
	xrun -sv \
		-timescale 1ns/1ps \
		-uvm $(UVM_HOME)/src \
		$(SRC) \
		-elab $(TOP) \
		-logfile compile.log
else ifeq ($(SIM),vsim)
	vlog -sv -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) \
		$(UVM_HOME)/src/uvm.sv \
		$(SRC) \
		-work work
endif
	@echo "  [OK] Compilation complete"

run: compile
	@echo "========================================"
	@echo "  Running simulation"
	@echo "========================================"
ifeq ($(SIM),vcs)
	./$(TOP)
else ifeq ($(SIM),xrun)
	./$(TOP)
else ifeq ($(SIM),vsim)
	vsim -c -do "run -all; quit"
endif
	@echo "  [OK] Simulation complete"

wave:
	@if [ -f "$(WAVE)" ]; then gtkwave $(WAVE); \
	else echo "Wavefile not found"; fi

clean:
	rm -rf $(TOP) work *.vcd *.log *.dag
	@echo "  [OK] Clean complete"

help:
	@echo "04-run-phase Makefile"
	@echo "Usage: make [target] [SIM=<simulator>]"
	@echo "Targets: all, compile, run, wave, clean"
