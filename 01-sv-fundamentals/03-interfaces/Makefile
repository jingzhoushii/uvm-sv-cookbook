SIM ?= vcs

all:
	vcs -sverilog +v2k tb/tb_interfaces.sv dut/bus.sv -l comp.log
	./simv -l run.log

clean:
	rm -f *.log *.vcd simv*

help:
	@echo "make [SIM=vcs|xrun|vsim]"
