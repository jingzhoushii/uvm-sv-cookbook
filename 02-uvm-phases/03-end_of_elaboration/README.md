# 03-end_of_elaboration - Elaboration 完成阶段

## 📚 知识点

- **end_of_elaboration_phase** 时机
- **printTopology()** 打印层次结构
- **组件参数检查**
- **动态修改配置**

## 📖 背景知识

### 执行时机

所有 `build_phase` 和 `connect_phase` 完成后，仿真开始前。

### 主要任务

1. 打印组件层次
2. 检查配置有效性
3. 调整组件参数

## 📂 文件结构

```
03-end_of_elaboration/
├── README.md
├── Makefile
└── examples/
    └── 01_eoe_phase.sv
```

## 📝 关键代码

```systemverilog
virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    
    // 打印层次结构
    printTopology();
    
    // 检查配置
    if (cfg.count == 0) begin
        `uvm_error("BAD_CFG", "Count cannot be zero")
    end
endfunction
```

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../02-connect-phase) | [下一章节](../04-run-phase)
