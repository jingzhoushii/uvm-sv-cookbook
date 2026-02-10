# ============================================================
# UVM-SV Cookbook - 公共文件列表
# ============================================================

# 公共接口
+incdir+./common/utils
./common/utils/interfaces.sv

# 公共 DUT
./common/dut/simple_bus.sv
./common/dut/simple_alu.sv
./common/dut/simple_register.sv

# 公共 TB
./common/tb/tb_base.sv
./common/tb/tb_env.sv

# UVM 库
# 注意：请根据实际环境设置 UVM_HOME
# ${UVM_HOME}/src/uvm.sv
