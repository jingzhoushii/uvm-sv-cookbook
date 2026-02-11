# 13-performance-optimization - 验证平台性能优化

## 📚 本章内容

| 子章节 | 难度 | 状态 | 内容 |
|--------|------|------|------|
| 01-zero-copy | 🔴 | ⚠️ | 零拷贝技术 + 数据竞争警告 |
| 02-transaction-pooling | 🔴 | ✅ | Transaction 池 |
| 03-object-reuse | 🔴 | ✅ | 对象复用 |
| 04-benchmark | 🔴 | ✅ | 性能测试框架 |

## ⚠️ Zero-Copy 警告

```systemverilog
// ⚠️ WARNING: Zero-copy performance optimization
// Risk: Data race if sequence modifies transaction after get_next_item()
//       returns but before item_done()
// Mitigation: Ensure blocking drive() or use copy() for critical fields
```

## 核心技术

### 1. 零拷贝 (Zero-Copy)

避免不必要的数据复制，减少内存开销。

```systemverilog
// ✅ 正确：使用 ref 参数
task process_ref(ref trans t);
    // 直接操作原始对象
endtask
```

### 2. Transaction 池

复用 transaction 对象，避免频繁创建/销毁。

```systemverilog
class txn_pool extends uvm_object;
    trans free_list[$];
    
    virtual function trans get();
        if (free_list.size() > 0)
            return free_list.pop_front();
        return trans::type_id::create("new");
    endfunction
endclass
```

### 3. 对象复用

在线程间传递对象引用。

```systemverilog
class reuse_driver extends uvm_driver#(trans);
    trans current;
    
    virtual task run_phase(uvm_phase phase);
        if (current == null)
            current = trans::type_id::create("t");
        seq_item_port.get_next_item(current);
        drive(current);
        seq_item_port.item_done(current);
    endtask
endclass
```

## 性能测试

```systemverilog
class perf_test extends uvm_test;
    int transaction_count = 100000;
    time start_time, end_time;
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        start_time = $time;
        run_sequences();
        end_time = $time;
        report_performance();
        phase.drop_objection(this);
    endtask
    
    function void report_performance();
        real throughput = transaction_count / ((end_time - start_time) * 1ns);
        `uvm_info("PERF", $sformatf("Throughput: %0.2f txn/us", throughput), UVM_LOW)
    endfunction
endclass
```

