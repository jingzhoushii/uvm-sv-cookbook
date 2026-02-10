# 06-uvm_sequencer - UVM 仲裁器

## 📚 知识点

- **uvm_sequencer** 基本原理
- **序列仲裁** (arbitration)
- **锁定机制** (lock, grab)
- **优先级** (priority)
- **响应处理**

## 📖 背景知识

### Sequencer 职责

```
Sequencer
├── 接收序列请求
├── 仲裁多个序列
├── 选择下一个序列执行
└── 传递事务给 Driver
```

### 仲裁策略

| 策略 | 说明 |
|------|------|
| SEQ_ARB_FIFO | 先进先出 |
| SEQ_ARB_WEIGHTED | 权重仲裁 |
| SEQ_ARB_RANDOM | 随机仲裁 |
| SEQ_ARB_STRICT_FIFO | 严格 FIFO |
| SEQ_ARB_STRICT_RANDOM | 严格随机 |

## 📝 关键代码

```systemverilog
class my_sequencer extends uvm_sequencer#(txn);
    `uvm_component_utils(my_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// 使用锁
seq.lock(sequencer);     // 独占访问
seq.unlock(sequencer);   // 释放

// 优先级
seq.set_arbitration(SEQ_ARB_WEIGHTED);
```

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../05-uvm_monitor) | [下一章节](../07-uvm_scoreboard)
