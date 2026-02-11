# 仿真器版本要求

## 已测试版本

| 仿真器 | 版本 | 状态 |
|--------|------|------|
| **VCS** | 2023.06-SP2 | ✅ 已测试 |
| **Xcelium** | 23.09 | ✅ 已测试 |
| **Questa** | 2023.4 | ✅ 已测试 |

## 版本要求

### VCS（推荐）
```bash
# 编译
make compile SIM=vcs

# 运行
make run SIM=vcs
```

### Xcelium
```bash
make compile SIM=xrun=xrun
```


make run SIM### Questa
```bash
make compile SIM=vsim
make run SIM=vsim
```

## 版本兼容性

- UVM 1.2 与以上版本兼容
- SystemVerilog 2017 标准
- 支持 IEEE 1800.2 部分特性

