# Mini SoC UVM Makefile

SIM ?= vcs

all: compile run

compile:
	@echo "Compiling Mini SoC..."
	vcs -sverilog +v2k \
		-f ../../filelist.f \
		+define+UVM_NO_DPI \
		-l comp.log

run:
	@echo "Running simulation..."
	./simv -l sim.log

debug:
	@echo "Running with waves..."
	./simv -ucli -do wave.do -l debug.log

cov:
	@echo "Generating coverage..."
	urg -dir simv.vdb -report coverage_rpt

clean:
	rm -rf simv* *.vcd *.fst *.log urg.vdb coverage_rpt

.PHONY: all compile run debug cov clean
