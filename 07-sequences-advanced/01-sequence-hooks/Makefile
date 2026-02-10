# ============================================================================
# Makefile - 01-sequence-hooks
# ============================================================================

SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

SRC = examples/*.sv

TOP = tb_hooks
WAVE = dump.vcd

.PHONY: all compile run clean help

all: compile run

compile:
	@echo "Compiling 01-sequence-hooks..."
ifeq ($(SIM),vcs)
	vcs -sverilog -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) \
		$(UVM_HOME)/src/uvm.sv \
		$(SRC) -o $(TOP) -l compile.log
endif

run: compile
ifeq ($(SIM),vcs)
	./$(TOP)
endif

clean:
	rm -rf $(TOP) work *.vcd *.log
