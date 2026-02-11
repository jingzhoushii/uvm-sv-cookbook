# ============================================================================
// Mini SoC Verification Platform Makefile
// ============================================================================

SIM ?= vcs
UVM_HOME ?= $(abspath ../uvm)

# 编译选项
COMPILE_OPTS = -sverilog +v2k -timescale=1ns/1ps
UVM_OPTS = +define+UVM_NO_DPI +incdir+$(UVM_HOME)/src

# 文件列表
FLIST = filelist.f

.PHONY: all compile run clean smoke stress help

all: compile run

compile:
	@echo "=== Compiling Mini SoC ==="
	vcs $(COMPILE_OPTS) $(UVM_OPTS) \
		-f $(FLIST) \
		-o simv \
		-l comp.log
	@echo "=== Compilation Complete ==="

run: compile
	@echo "=== Running Simulation ==="
	./simv -l sim.log
	@echo "=== Complete ==="

smoke:
	@echo "=== Smoke Test ==="
	vcs $(COMPILE_OPTS) $(UVM_OPTS) -f $(FLIST) -o simv_smoke +UVM_TESTNAME=smoke_test
	./simv_smoke -l smoke.log

stress:
	@echo "=== Stress Test ==="
	vcs $(COMPILE_OPTS) $(UVM_OPTS) -f $(FLIST) -o simv_stress +UVM_TESTNAME=stress_test
	./simv_stress -l stress.log

clean:
	rm -rf simv* *.vcd *.fst *.log waves.* ダンプ work*

help:
	@echo "Mini SoC Verification Platform"
	@echo ""
	@echo "Targets:"
	@echo "  all    - Compile and run"
	@echo "  compile - Compile only"
	@echo "  run    - Run simulation"
	@echo "  smoke  - Run smoke test"
	@echo "  stress - Run stress test"
	@echo "  clean  - Clean build files"

