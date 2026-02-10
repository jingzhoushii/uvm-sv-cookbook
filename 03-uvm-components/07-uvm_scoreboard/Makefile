# Makefile - 07-uvm_scoreboard
SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

SRC = $(wildcard examples/*.sv)

TOP = tb_07-uvm_scoreboard
WAVE = dump.vcd

all: compile run
compile:
	@echo "Compiling 03-uvm-components/07-uvm_scoreboard..."
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
