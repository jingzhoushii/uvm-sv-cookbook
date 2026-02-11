# Makefile - 03-factory-override
SIM ?= vcs
UVM_HOME ?= $(abspath ../uvm)

SRC = $(wildcard examples/*.sv)

TOP = tb_03-factory-override
WAVE = dump.vcd

all: compile run
compile:
	@echo "Compiling 06-configuration/03-factory-override..."
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
