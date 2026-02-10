# ============================================================
# Makefile - 01-data-types
# ============================================================

SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

# 源文件
SRC = examples/*.sv \
      tb/*.sv \
      dut/*.sv \
      ../common/utils/interfaces.sv

TOP = tb_data_types
WAVE = dump.vcd

.PHONY: all compile run clean help

all: compile run

compile:
	@echo "========================================"
	@echo "  Compiling: 01-data-types"
	@echo "  Simulator: $(SIM)"
	@echo "========================================"
ifeq ($(SIM),vcs)
	vcs -sverilog -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) \
		+incdir+../common \
		$(UVM_HOME)/src/uvm.sv \
		$(SRC) \
		-o $(TOP) \
		-l compile.log
endif
	@echo "  [OK] Compilation complete"

run: compile
	@echo "========================================"
	@echo "  Running simulation"
	@echo "========================================"
ifeq ($(SIM),vcs)
	./$(TOP)
endif
	@echo "  [OK] Simulation complete"

clean:
	@echo "Cleaning..."
	rm -rf $(TOP) work *.vcd *.log *.dag
	@echo "  [OK] Clean complete"

help:
	@echo "UVM-SV Cookbook - 01-data-types"
	@echo "Usage: make [target] [SIM=<simulator>]"
	@echo "Targets: all, compile, run, clean"
