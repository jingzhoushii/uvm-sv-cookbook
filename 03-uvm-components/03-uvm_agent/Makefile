# ============================================================================
# Makefile - AXI Agent 完整示例
# 支持: VCS, Xcelium, Questa
# ============================================================================

SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

# ============================================================================
# 源文件
# ============================================================================
TB_SRC = axi_if.sv

AGENT_SRC = \
    axi_config.sv \
    axi_transaction.sv \
    axi_sequencer.sv \
    axi_driver.sv \
    axi_monitor.sv \
    axi_agent.sv \
    axi_scoreboard.sv \
    axi_env.sv \
    axi_base_seq.sv \
    axi_write_seq.sv

TEST_SRC = tests/base_test.sv

DUT_SRC = 

# 所有源文件
SRC = $(TB_SRC) $(AGENT_SRC) $(TEST_SRC) $(DUT_SRC)

# ============================================================================
# 输出
# ============================================================================
TOP = simv
WAVE = dump.vcd

.PHONY: all compile run clean test$(SIM) help

all: compile run

# ============================================================================
# 编译
# ============================================================================
compile:
	@echo "========================================"
	@echo "  Compiling AXI Agent Example"
	@echo "  Simulator: $(SIM)"
	@echo "========================================"
ifeq ($(SIM),vcs)
	vcs -sverilog -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) \
		$(UVM_HOME)/src/uvm.sv \
		$(SRC) \
		-o $(TOP) \
		-l compile.log \
		+define+UVM_NO_DEPRECATED
	@echo "  [OK] Compilation complete"
else ifeq ($(SIM),xrun)
	xrun -sv \
		-timescale 1ns/1ps \
		-uvm $(UVM_HOME)/src \
		$(SRC) \
		-elab $(TOP) \
		-logfile compile.log
	@echo "  [OK] Compilation complete"
else ifeq ($(SIM),vsim)
	vlog -sv -timescale 1ns/1ps \
		+incdir+$(UVM_HOME) \
		$(UVM_HOME)/src/uvm.sv \
		$(SRC) \
		-work work
endif

# ============================================================================
# 运行
# ============================================================================
run: compile
	@echo "========================================"
	@echo "  Running simulation"
	@echo "========================================"
ifeq ($(SIM),vcs)
	./$(TOP) -l $(WAVE)
else ifeq ($(SIM),xrun)
	./$(TOP) -l $(WAVE)
else ifeq ($(SIM),vsim)
	vsim -c -do "run -all; quit"
endif
	@echo "  [OK] Simulation complete"

# ============================================================================
# 测试
# ============================================================================
test: compile
	@echo "========================================"
	@echo "  Running tests"
	@echo "========================================"
ifeq ($(SIM),vcs)
	./$(TOP) +UVM_TESTNAME=base_test -l test.log
else ifeq ($(SIM),xrun)
	./$(TOP) -uvm_testname=base_test -l test.log
endif

# ============================================================================
# 波形
# ============================================================================
wave:
ifeq ($(SIM),vcs)
	@if [ -f "$(WAVE)" ]; then \
		gtkwave $(WAVE); \
	else \
		echo "Wavefile $(WAVE) not found"; \
	fi
else
	@echo "Wave viewing not configured for $(SIM)"
endif

# ============================================================================
# 清理
# ============================================================================
clean:
	@echo "Cleaning..."
	rm -rf $(TOP) work *.vcd *.log *.dag DVEfiles
	@echo "  [OK] Clean complete"

# ============================================================================
# 帮助
# ============================================================================
help:
	@echo "AXI Agent Example - Makefile"
	@echo ""
	@echo "Usage: make [target] [SIM=<simulator>]"
	@echo ""
	@echo "Targets:"
	@echo "  all      - Compile and run (default)"
	@echo "  compile  - Compile only"
	@echo "  run      - Run simulation"
	@echo "  test     - Run with test"
	@echo "  wave     - Open waveform"
	@echo "  clean    - Clean build files"
	@echo ""
	@echo "Simulators:"
	@echo "  vcs   - Synopsys VCS (default)"
	@echo "  xrun  - Cadence Xcelium"
	@echo "  vsim  - Siemens Questa"
	@echo ""
	@echo "Examples:"
	@echo "  make                    # VCS compile and run"
	@echo "  make SIM=xrun          # Xcelium"
	@echo "  make clean              # Clean"
