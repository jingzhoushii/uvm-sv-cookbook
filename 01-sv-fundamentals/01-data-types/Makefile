# Makefile: 01-data-types
# SystemVerilog Data Types Demo

SIM ?= vcs
UVM_HOME ?= /path/to/uvm-1800.2-2021

.PHONY: all compile run clean waves help

all: compile run

compile:
	@echo "编译中..."
ifeq ($(SIM),vcs)
	vcs -sverilog +v2k -ntb_opts uvm \
		-l comp.log \
		tb/tb_data_types.sv \
		dut/alu.sv
else ifeq ($(SIM),xrun)
	xrun -sv -uvm -l comp.log \
		tb/tb_data_types.sv \
		dut/alu.sv
else ifeq ($(SIM),vsim)
	vlog -sv -uvm -work work \
		tb/tb_data_types.sv \
		dut/alu.sv
endif
	@echo "✅ 编译完成"

run:
	@echo "运行测试..."
ifeq ($(SIM),vcs)
	./simv -l run.log
else ifeq ($(SIM),xrun)
	xrun -R
else ifeq ($(SIM),vsim)
	vsim -c -do "run -all; quit"
endif

waves:
	gtkwave dump.vcd 2>/dev/null || echo "请先运行测试生成波形"

clean:
	rm -f *.log *.vcd simv* DVEfiles/ work/

help:
	@echo "使用方法: make [SIM=vcs|xrun|vsim]"
	@echo "  make          - 编译并运行"
	@echo "  make compile  - 仅编译"
	@echo "  make run     - 仅运行"
	@echo "  make waves   - 查看波形"
	@echo "  make clean   - 清理"
