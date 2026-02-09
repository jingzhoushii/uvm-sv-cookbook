#!/bin/bash
# run_xrun.sh - Xcelium 编译运行脚本

if [ -z "$XCELIUM_HOME" ]; then
    echo "❌ 错误: 请设置 XCELIUM_HOME 环境变量"
    exit 1
fi

UVM_HOME=${UVM_HOME:-/path/to/uvm-1800.2-2021}

echo "=== Xcelium 编译 ==="
xrun -sv \
    -uvm \
    -l comp.log \
    -f ../filelist.f

echo "=== Xcelium 运行 ==="
xrun -R

echo "完成"
