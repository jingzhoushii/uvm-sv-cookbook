SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

SRC = examples/*.sv
TOP = tb_tlm
WAVE = dump.vcd

all: compile run

compile:
	@echo "Compiling 01-put-get-ports..."
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
