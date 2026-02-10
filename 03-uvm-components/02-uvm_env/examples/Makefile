# ============================================================================
# Makefile - Memory Controller Example
# ============================================================================

SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

SRC = \
    mem_if.sv \
    mem_dut.sv \
    mem_transaction.sv \
    mem_config.sv \
    mem_driver.sv \
    mem_monitor.sv \
    mem_env.sv \
    mem_seq.sv \
    tests/mem_test.sv \
    tb_mem.sv

TOP = tb_mem
WAVE = dump.vcd

.PHONY: all compile run clean help

all: compile run

compile:
	@echo "========================================"
	@echo "  Compiling Memory Controller Example"
	@echo "========================================"
ifeq ($(SIM),vcs)
	vcs -sverilog -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) \
		$(UVM_HOME)/src/uvm.sv \
		$(SRC) \
		-o $(TOP) \
		-l compile.log
endif

run: compile
ifeq ($(SIM),vcs)
	./$(TOP)
endif

clean:
	rm -rf $(TOP) work *.vcd *.log

help:
	@echo "Memory Controller Example Makefile"
