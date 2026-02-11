# UVM 路径配置
UVM_HOME ?= $(abspath ../uvm)
UVM_SRC  ?= $(UVM_HOME)/src
UVM_INC  ?= $(UVM_SRC)

# 编译选项
COMPILE_OPTS = -sverilog +v2k -timescale=1ns/1ps
UVM_OPTS    = +define+UVM_NO_DPI +incdir+$(UVM_INC)

# VCS 编译
vcs_compile:
	vcs $(COMPILE_OPTS) $(UVM_OPTS) -f filelist.f -l comp.log

# 运行
vcs_run:
	./simv -l sim.log

# 清理
clean:
	rm -rf simv* *.vcd *.fst *.log *.・ダンプ waves.*

