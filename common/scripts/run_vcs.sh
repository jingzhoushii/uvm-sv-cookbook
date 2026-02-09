#!/bin/bash
# run_vcs.sh - VCS 编译运行脚本

# 环境检查
if [ -z "$VCS_HOME" ]; then
    echo "❌ 错误: 请设置 VCS_HOME 环境变量"
    exit 1
fi

# 默认设置
UVM_HOME=${UVM_HOME:-/path/to/uvm-1800.2-2021}
COMPILE_LOG="comp.log"
RUN_LOG="run.log"

# 编译
echo "=== VCS 编译 ==="
vcs -sverilog +v2k \
    -ntb_opts uvm \
    -l $COMPILE_LOG \
    -f ../filelist.f \
    2>&1 | tee $COMPILE_LOG

if [ $? -ne 0 ]; then
    echo "❌ 编译失败! 查看 $COMPILE_LOG"
    exit 1
fi

echo "✅ 编译完成"

# 运行
echo "=== VCS 运行 ==="
./simv -l $RUN_LOG 2>&1 | tee $RUN_LOG

echo ""
echo "=== 完成 ==="
echo "编译日志: $COMPILE_LOG"
echo "运行日志: $RUN_LOG"
