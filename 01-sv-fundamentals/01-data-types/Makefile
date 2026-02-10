# ============================================================================
# Makefile - 01-data-types (完整版)
# ============================================================================

SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

# 源文件
SRC = examples/*.sv tb/*.sv dut/*.sv

TOP = tb_data_types
WAVE = dump.vcd

.PHONY: all compile run clean help test

all: compile run

compile:
	@echo "========================================"
	@echo "  Compiling: 01-data-types"
	@echo "  Simulator: $(SIM)"
	@echo "========================================"
ifeq ($(SIM),vcs)
	vcs -sverilog -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) \
		$(UVM_HOME)/src/uvm.sv \
		$(SRC) \
		-o $(TOP) \
		-l compile.log
endif
	@echo "  [OK]"

run: compile
	@echo "========================================"
	@echo "  Running"
	@echo "========================================"
ifeq ($(SIM),vcs)
	./$(TOP)
endif
	@echo "  [OK]"

clean:
	rm -rf $(TOP) work *.vcd *.log *.dag

help:
	@echo "01-data-types Makefile"
	@echo "Usage: make [target] [SIM=<simulator>]"
