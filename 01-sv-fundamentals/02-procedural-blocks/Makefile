SIM ?= vcs
UVM_HOME ?= $(abspath ../uvm)

SRC = examples/*.sv
TOP = tb_procedural
WAVE = dump.vcd

all: compile run

compile:
	@echo "Compiling 02-procedural-blocks..."
ifeq ($(SIM),vcs)
	vcs -sverilog -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) $(UVM_HOME)/src/uvm.sv \
		$(SRC) -o $(TOP) -l compile.log
endif

run: compile
ifeq ($(SIM),vcs)
	./$(TOP)
endif

clean:
	rm -rf $(TOP) work *.vcd *.log
