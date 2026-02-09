#!/bin/bash
# run_questa.sh - Questa 编译运行脚本

if [ -z "$QUESTA_HOME" ]; then
    echo "❌ 错误: 请设置 QUESTA_HOME 环境变量"
    exit 1
fi

UVM_HOME=${UVM_HOME:-/path/to/uvm-1800.2-2021}

echo "=== Questa 编译 ==="
vlog -sv \
    -uvm \
    -work work \
    -f ../filelist.f

echo "=== Questa 运行 ==="
vsim -c -do "run -all; quit"

echo "完成"
