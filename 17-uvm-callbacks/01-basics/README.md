# 📚 UVM 回调基础

## 回调类层次

```mermaid
classDiagram
    class uvm_void {
        <<abstract>>
    }
    
    class uvm_object {
    }
    
    class uvm_callback {
        <<abstract>>
        +pre_xxx()
        +post_xxx()
    }
    
    class uvm_callbacks#(T, CB) {
        <<static>>
        +add()
        +delete()
        +display()
    }
    
    uvm_void <|-- uvm_object
    uvm_object <|-- uvm_callback
    uvm_callback <|-- user_callback
```

## 基本结构

### 1. 定义回调类

```systemverilog
class driver_callback extends uvm_callback;
    `uvm_object_utils(driver_callback)
    
    // 前置回调
    virtual task pre_send(uvm_driver#(bus_trans) drv, 
                          bus_trans tr);
        `uvm_info("CB_PRE", 
            $sformatf("Before sending: %s", tr.convert2str()), 
            UVM_LOW)
    endtask
    
    // 后置回调
    virtual task post_send(uvm_driver#(bus_trans) drv,
                           bus_trans tr);
        `uvm_info("CB_POST", 
            $sformatf("After sending: %s", tr.convert2str()), 
            UVM_LOW)
    endtask
endclass
```

### 2. 声明回调池

```systemverilog
// 在 driver 中声明回调池
class my_driver extends uvm_driver#(bus_trans);
    `uvm_component_utils(my_driver)
    
    // 声明回调池
    typedef uvm_callbacks#(my_driver, driver_callback) cb_pool_t;
    cb_pool_t m_cbs;
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            
            // 调用前置回调
            m_cbs.pre_send(this, req);
            
            drive(req);
            
            // 调用后置回调
            m_cbs.post_send(this, req);
            
            seq_item_port.item_done();
        end
    endtask
endclass
```

### 3. 注册回调

```systemverilog
// 方法 1: 在测试中注册
class my_test extends uvm_test;
    virtual function void build_phase(uvm_phase phase);
        driver_callback cb = new("cb");
        uvm_callbacks#(my_driver)::add(null, cb);
    endfunction
endclass

// 方法 2: 使用宏注册
`uvm_register_cb(my_driver, driver_callback)

// 方法 3: 全局注册
initial begin
    driver_callback cb = new("global_cb");
    uvm_callbacks#(my_driver)::add(null, cb);
end
```

## 完整示例

```systemverilog
// ==========================================
// 回调定义
// ==========================================
class timing_callback extends uvm_callback;
    `uvm_object_utils(timing_callback)
    
    int transaction_count = 0;
    real total_latency = 0;
    
    virtual task pre_send(uvm_driver#(bus_trans) drv, 
                          bus_trans tr);
        tr.start_time = $realtime();
        `uvm_info("TIMING_CB", 
            $sformatf("Transaction %0d started", transaction_count), 
            UVM_LOW)
    endtask
    
    virtual task post_send(uvm_driver#(bus_trans) drv,
                           bus_trans tr);
        real end_time = $realtime();
        real latency = end_time - tr.start_time;
        total_latency += latency;
        transaction_count++;
        `uvm_info("TIMING_CB", 
            $sformatf("Transaction %0d completed, latency: %0t", 
                transaction_count-1, latency), 
            UVM_LOW)
    endtask
endclass

// ==========================================
// Driver with Callbacks
// ==========================================
class monitored_driver extends uvm_driver#(bus_trans);
    `uvm_component_utils(monitored_driver)
    
    typedef uvm_callbacks#(monitored_driver, 
                           timing_callback) cb_pool_t;
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            
            // Callback hooks
            cb_pool_t::pre_send(this, req);
            
            drive(req);
            
            cb_pool_t::post_send(this, req);
            
            seq_item_port.item_done();
        end
    endtask
    
    virtual protected void drive(bus_trans t);
        // 驱动逻辑
    endtask
endclass

// ==========================================
// Test with Callback
// ==========================================
class callback_test extends uvm_test;
    `uvm_component_utils(callback_test)
    
    monitored_driver drv;
    timing_callback timing_cb;
    
    virtual function void build_phase(uvm_phase phase);
        drv = monitored_driver::type_id::create("drv", this);
        timing_cb = new("timing_cb");
        uvm_callbacks#(monitored_driver)::add(drv, timing_cb);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_callbacks#(monitored_driver)::display();
    endfunction
endclass
```

## 回调类型

| 类型 | 用途 | 示例 |
|------|------|------|
| `uvm_callback` | 基础回调类 | 所有用户回调的基类 |
| `uvm_callbacks#(T)` | 回调池模板 | `uvm_callbacks#(driver)` |
| `uvm_callbacks#(T,CB)` | 带类型的回调池 | 指定回调类型 |

## 最佳实践

| 实践 | 说明 |
|------|------|
| 使用有意义的回调名 | `timing_cb` > `cb1` |
| 合理命名回调方法 | `pre_send` > `pre_cb1` |
| 避免在回调中阻塞 | 可能影响主流程 |
| 文档化回调行为 | 方便其他开发者使用 |

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| 回调未执行 | 检查是否正确注册 |
| 多个回调顺序 | 按注册顺序执行 |
| 回调中访问组件 | 使用 `uvm_callbacks#(T)::get()` |

## 进阶阅读

- [高级用法](../02-advanced/)
- [工厂对比](../03-factory-comparison/)
