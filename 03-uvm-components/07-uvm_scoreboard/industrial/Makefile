# UVM 路径配置
UVM_HOME ?= ../../uvm
UVM_SRC  ?= /src
UVM_INC  ?= 

COMPILE_OPTS = -sverilog +v2k -timescale=1ns/1ps
UVM_OPTS    = +define+UVM_NO_DPI +incdir+

.PHONY: all clean compile run

all: compile run

compile:
	vcs   -f filelist.f -l comp.log

run:
	./simv -l sim.log

clean:
	rm -rf simv* *.vcd *.fst *.log waves.*
