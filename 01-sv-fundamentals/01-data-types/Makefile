# ============================================================
# Makefile: 01-data-types
# Description: SystemVerilog Data Types Examples
# ============================================================

SIM ?= vcs
UVM_HOME ?= $(shell uvm_home 2>/dev/null || echo "/opt/uvm-1800.2-2021")
TOP := tb_data_types

.PHONY: all compile run clean waves help test-vcs test-xrun test-vsim

# 默认目标
all: compile run

# 编译
compile:
	@echo "========================================"
	@echo "  Compiling 01-data-types"
	@echo "========================================"
ifeq ($(SIM),vcs)
	vcs -sverilog +v2k \
		-ntb_opts uvm \
		-l compile.log \
		-f filelist.f \
		+incdir+$(UVM_HOME)/src
else ifeq ($(SIM),xrun)
	xrun -sv \
		-uvm -uvmhome $(UVM_HOME) \
		-l compile.log \
		-f filelist.f
else ifeq ($(SIM),vsim)
	vlog -sv -work work \
		-uvm -i $(UVM_HOME)/src/uvm_defines.svh \
		-f filelist.f
endif
	@echo ""
	@echo "✅ 编译完成 (compile.log)"

# 运行
run:
	@echo ""
	@echo "========================================"
	@echo "  Running Simulation"
	@echo "========================================"
ifeq ($(SIM),vcs)
	./$(TOP) -l run.log
else ifeq ($(SIM),xrun)
	xrun -R
else ifeq ($(SIM),vsim)
	vsim -c -work work $(TOP) -do "run -all; quit"
endif
	@echo ""
	@echo "✅ 运行完成"

# 查看波形
waves:
	@if [ -f "$(TOP).vcd" ]; then \
		gtkwave $(TOP).vcd; \
	elif [ -f "dump.vcd" ]; then \
		gtkwave dump.vcd; \
	else \
		echo "❌ 未找到波形文件，请先运行: make"; \
	fi

# 清理
clean:
	@echo "清理生成的文件..."
	rm -f $(TOP) $(TOP).vvp $(TOP).vcd dump.vcd
	rm -f *.log *.wlf work/ 2>/dev/null || true
	rm -f DVEfiles/ urg_report/ 2>/dev/null || true
	rm -f transcript vsim.wlf 2>/dev/null || true
	@echo "✅ 清理完成"

# 帮助
help:
	@echo ""
	@echo "╔═══════════════════════════════════════════════════════╗"
	@echo "║  01-data-types - Makefile Help                     ║"
	@echo "╚═══════════════════════════════════════════════════════╝"
	@echo ""
	@echo "用法: make [目标] [SIM=<simulator>]"
	@echo ""
	@echo "目标:"
	@echo "  make           - 编译并运行 (默认)"
	@echo "  make compile   - 仅编译"
	@echo "  make run       - 仅运行"
	@echo "  make waves    - 查看波形 (需要 GTKWave)"
	@echo "  make clean    - 清理生成的文件"
	@echo "  make help     - 显示此帮助信息"
	@echo ""
	@echo "仿真器:"
	@echo "  SIM=vcs       - Synopsys VCS (默认)"
	@echo "  SIM=xrun      - Cadence Xcelium"
	@echo "  SIM=vsim       - Siemens Questa"
	@echo ""
	@echo "示例:"
	@echo "  make SIM=vcs"
	@echo "  make compile SIM=xrun"
	@echo "  make clean SIM=vsim"
	@echo ""

# 便捷测试目标
test-vcs:
	$(MAKE) clean SIM=vcs
	$(MAKE) all SIM=vcs

test-xrun:
	$(MAKE) clean SIM=xrun
	$(MAKE) all SIM=xrun

test-vsim:
	$(MAKE) clean SIM=vsim
	$(MAKE) all SIM=vsim

# Filelist
filelist.f:
	@echo "# 01-data-types 文件列表" > $@
	@echo "+incdir+." >> $@
	@echo "+incdir+../common/utils" >> $@
	@echo "dut/simple_alu.sv" >> $@
	@echo "examples/01_basic_types.sv" >> $@
	@echo "examples/02_arrays.sv" >> $@
	@echo "examples/03_struct_enum.sv" >> $@
	@echo "examples/04_type_casting.sv" >> $@
	@echo "tb/tb_data_types.sv" >> $@
