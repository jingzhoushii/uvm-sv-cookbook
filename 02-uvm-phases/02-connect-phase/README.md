# 02-connect-phase - UVM 连接阶段

## 📚 知识点

- **connect_phase** 执行顺序（自顶向下）
- **TLM 端口连接** (`connect()`)
- **Driver-Sequencer 连接**
- **Analysis 端口连接**

## 📖 背景知识

### 与 build_phase 的区别

| 特性 | build_phase | connect_phase |
|------|-------------|---------------|
| 顺序 | 自底向上 | 自顶向下 |
| 时机 | 所有组件创建后 | 所有组件连接前 |
| 任务 | 创建组件 | 建立连接 |

## 📂 文件结构

```
02-connect-phase/
├── README.md
├── Makefile
└── examples/
    └── 01_connect_phase.sv
```

## 🚀 快速开始

```bash
cd 02-uvm-phases/02-connect-phase
make
```

## 📝 关键代码

```systemverilog
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Driver-Sequencer 连接
    driver.seq_item_port.connect(sequencer.seq_item_export);
    
    // Monitor-Scoreboard 连接
    monitor.ap.connect(scoreboard.analysis_export);
endfunction
```

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../01-build-phase) | [下一章节](../03-end_of_elaboration)
