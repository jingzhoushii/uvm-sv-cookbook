# Makefile - 01-interrupt-basics
SIM ?= vcs
UVM_HOME ?= $(abspath ../uvm)

SRC = $(wildcard examples/*.sv)

TOP = tb_01-interrupt-basics
WAVE = dump.vcd

all: compile run
compile:
	@echo "Compiling 10-interrupt-verification/01-interrupt-basics..."
	@if [ "" = "vcs" ]; then \
		vcs -sverilog -timescale 1ns/1ps \
			+incdir+$(UVM_HOME) \
			$(UVM_HOME)/src/uvm.sv \
			$(SRC) \
			-o $(TOP) -l compile.log 2>/dev/null || echo "VCS not available"; \
	fi

run:
	@if [ -f "$(TOP)" ]; then \
		./$(TOP); \
	fi

clean:
	rm -rf $(TOP) work *.vcd *.log

.PHONY: all compile run clean
