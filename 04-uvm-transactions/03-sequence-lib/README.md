# 03-sequence-lib - 序列库

## 📚 知识点

- **序列库** 组织和管理
- **序列类继承**
- **可配置的序列行为**

## 📖 背景知识

序列库是一组预定义的序列，用于常见的验证场景。

## 📝 示例

```systemverilog
// 读序列
class read_seq extends uvm_sequence#(txn);
    bit [31:0] addr;
    
    virtual task body();
        // 发送读请求
    endtask
endclass

// 写序列
class write_seq extends uvm_sequence#(txn);
    bit [31:0] addr, data;
    
    virtual task body();
        // 发送写请求
    endtask
endclass
```

---

