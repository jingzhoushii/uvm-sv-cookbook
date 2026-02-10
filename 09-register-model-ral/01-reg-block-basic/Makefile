# Makefile - 01-reg-block-basic
SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

SRC = $(wildcard examples/*.sv)

TOP = tb_01-reg-block-basic
WAVE = dump.vcd

all: compile run
compile:
	@echo "Compiling 09-register-model-ral/01-reg-block-basic..."
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
