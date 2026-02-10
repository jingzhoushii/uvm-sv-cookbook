# 07-uvm_scoreboard - UVM 计分板

## 📚 知识点

- **uvm_scoreboard** 作用和结构
- **uvm_analysis_imp** 接收数据
- **TLM 端口连接**
- **期望值 vs 实际值比较**

## 📖 背景知识

### Scoreboard 职责

```
Scoreboard
├── 接收参考模型输出 (expected)
├── 接收被测设计输出 (actual)
└── 比较并报告结果
```

### 常见架构

| 类型 | 说明 |
|------|------|
| **Self-Checking** | 内置比较逻辑 |
| **Reference Model** | 用参考模型生成期望值 |
| **Checker Only** | 只做比较 |

## 📝 关键代码

```systemverilog
class my_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp#(txn, my_scoreboard) act_imp;
    uvm_analysis_imp#(txn, my_scoreboard) exp_imp;
    
    txn expected_q[$];
    
    virtual function void write(txn tr);
        // 接收数据并比较
    endfunction
endclass
```

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../06-uvm_sequencer)
