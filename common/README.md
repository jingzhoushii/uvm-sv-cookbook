# Common - 基础验证框架层

## 目录结构

```
common/
├── base_env/           # 基础 UVM 骨架
│   └── base_env.sv    # env/agent/driver/monitor 基类
│
├── base_lib/           # 通用工具类
│   └── base_lib.sv    # 工具函数/配置对象/序列基类
│
├── vip/                # 通用虚拟 IP 示例
│   └── uart_vip.sv    # UART VIP 示例
│
├── dut/                # 通用 DUT
│   └── simple_dut.sv  # 简单 DUT
│
├── scripts/           # 运行脚本
│   └── run.py         # Python 运行脚本
│
└── docs/              # 文档
    └── architecture.md
```

## 使用方法

```systemverilog
`include "base_env.sv"
`include "base_lib.sv"

// 继承使用
class my_env extends base_env;
    // 直接使用基类功能
endclass
```

## 核心类

| 类 | 说明 |
|----|------|
| `base_env` | 基础环境容器 |
| `base_agent` | 基础 Agent |
| `base_driver` | 基础 Driver |
| `base_monitor` | 基础 Monitor |
| `base_trans` | 基础 Transaction |
| `base_config` | 基础配置对象 |
| `base_seq` | 基础序列 |

