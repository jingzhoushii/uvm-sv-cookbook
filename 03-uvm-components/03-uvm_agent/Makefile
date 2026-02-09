SIM ?= vcs
UVM_HOME ?= /path/to/uvm

all:
	vcs -sverilog +v2k -ntb_opts uvm tb/tb_agent.sv -l comp.log
	./simv -l run.log

clean:
	rm -f *.log simv*

help:
	@echo "make [SIM=vcs]"
