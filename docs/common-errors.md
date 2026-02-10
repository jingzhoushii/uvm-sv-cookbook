# ⚠️ 常见错误和解决方案

本文档收集初学者在使用 SystemVerilog 和 UVM 时容易犯的错误。

---

## SystemVerilog 常见错误

### 1️⃣ 变量未初始化

**错误代码**
```systemverilog
int a;          // 未初始化
$display(a);   // 输出 X 或 0
```

**正确代码**
```systemverilog
int a = 0;      // 显式初始化
```

**说明**
- 局部变量默认是 X
- 类成员变量在 `new()` 中初始化

---

### 2️⃣ 数组越界

**错误代码**
```systemverilog
bit [7:0] arr[4];
arr[4] = 8'hFF;  // 越界！索引 0-3
```

**正确代码**
```systemverilog
bit [7:0] arr[4];
arr[3] = 8'hFF;  // 正确：最后一个索引是 3
```

**调试技巧**
```systemverilog
foreach (arr[i])
    $display("arr[%0d] = 0x%0h", i, arr[i]);
```

---

### 3️⃣ always_comb 敏感列表

**错误代码**
```systemverilog
always_comb begin
    y = a + b;
    a = c;  // 错误！组合逻辑中不能有过程性赋值
end
```

**正确代码**
```systemverilog
logic [7:0] y;
always_comb begin
    y = a + b;
end
```

---

### 4️⃣ 阻塞 vs 非阻塞赋值混淆

**错误代码**（时序逻辑用阻塞赋值）
```systemverilog
always @(posedge clk) begin
    q = d;  // 应该用 <=
end
```

**正确代码**
```systemverilog
always @(posedge clk) begin
    q <= d;  // 非阻塞赋值用于时序逻辑
end
```

**对比**
| 场景 | 阻塞 (=) | 非阻塞 (<=) |
|------|----------|-------------|
| 组合逻辑 | ✅ | ❌ |
| 时序逻辑 | ❌ | ✅ |
| 连续赋值 | ✅ (=) | ❌ |

---

### 5️⃣ 类型宽度不匹配

**错误代码**
```systemverilog
bit [7:0] a = 8'hFF;
bit [3:0] b;
b = a;  // 截断警告！
```

**正确代码**
```systemverilog
bit [7:0] a = 8'hFF;
bit [3:0] b;
b = a[3:0];  // 显式截断
```

---

### 6️⃣ randc 使用错误

**错误代码**
```systemverilog
class bad;
    randc bit [1:0] x;
endclass
```

**正确代码**
```systemverilog
class good;
    randc bit [1:0] x;  // 只支持 2 的幂次方位宽
endclass
```

**说明**
- `randc` 只支持 2^n 位宽
- 例如：1, 2, 4, 8, 16...

---

## UVM 常见错误

### 1️⃣ Objection 未正确处理

**错误代码**
```systemverilog
task run_phase(uvm_phase phase);
    #100;  // objection 未提起，仿真立即结束
endtask
```

**正确代码**
```systemverilog
task run_phase(uvm_phase phase);
    phase.raise_objection(this);  // 必须提起
    #100;
    phase.drop_objection(this);    // 必须放下
endtask
```

**重要原则**
- `raise_objection` 和 `drop_objection` 必须配对
- 忘记 `drop_objection` 会导致仿真挂起

---

### 2️⃣ Config DB 获取失败

**错误代码**
```systemverilog
class my_driver extends uvm_driver;
    virtual dut_if vif;
    
    virtual function void build_phase(uvm_phase phase);
        // 未检查 get 返回值
        uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif);
    endtask
endclass
```

**正确代码**
```systemverilog
class my_driver extends uvm_driver;
    virtual dut_if vif;
    
    virtual function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
            `uvm_error("NOVIF", "Failed to get vif from config_db")
        end else begin
            `uvm_info("GOTVIF", "Got vif!", UVM_LOW)
        end
    endtask
endclass
```

---

### 3️⃣ Sequence Item 未创建

**错误代码**
```systemverilog
class my_seq extends uvm_sequence#(my_txn);
    task body();
        start_item(req);  // req 未创建！
        req.randomize();
        finish_item(req);
    endtask
endclass
```

**正确代码**
```systemverilog
class my_seq extends uvm_sequence#(my_txn);
    task body();
        req = my_txn::type_id::create("req");  // 先创建
        start_item(req);
        req.randomize();
        finish_item(req);
    endtask
endclass
```

---

### 4️⃣ Port 连接错误

**错误代码**
```systemverilog
// 缺少 connect_phase
class my_env extends uvm_env;
    my_driver drv;
    my_sequencer sqr;
    
    virtual function void build_phase(uvm_phase phase);
        drv = my_driver::type_id::create("drv", this);
        sqr = my_sequencer::type_id::create("sqr", this);
    endfunction
    
    // 缺少 connect_phase！
endclass
```

**正确代码**
```systemverilog
class my_env extends uvm_env;
    my_driver drv;
    my_sequencer sqr;
    
    virtual function void build_phase(uvm_phase phase);
        drv = my_driver::type_id::create("drv", this);
        sqr = my_sequencer::type_id::create("sqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);  // 必须连接
    endfunction
endclass
```

---

### 5️⃣ Factory Override 无效

**错误代码**
```systemverilog
// 忘记在 build_phase 之前调用
initial begin
    my_driver::type_id::set_type_override(my_new_driver::get_type());
    run_test();  // 应该在 run_test 之前
end
```

**正确代码**
```systemverilog
initial begin
    my_driver::type_id::set_type_override(my_new_driver::get_type());
    run_test("my_base_test");
end

class my_base_test extends uvm_test;
    virtual function void build_phase(uvm_phase phase);
        my_driver::type_id::set_type_override(my_new_driver::get_type());
    endfunction
endclass
```

---

### 6️⃣ Phase 超时

**错误代码**
```systemverilog
class my_test extends uvm_test;
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin  // 死循环！
            #10;
        end
        phase.drop_objection(this);  // 永远执行不到
    endtask
endclass
```

**正确代码**
```systemverilog
class my_test extends uvm_test;
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        for (int i = 0; i < 100; i++) begin
            #10;
        end
        
        phase.drop_objection(this);
    endtask
endclass
```

---

### 7️⃣ Coverage 未采样

**错误代码**
```systemverilog
covergroup cg;
    coverpoint addr;
    cross addr, data;
endgroup

class my_monitor extends uvm_monitor;
    covergroup cg;
    
    task run_phase(uvm_phase phase);
        // 忘记调用 sample()
        forever @ (posedge clk) begin
            // ...
        end
    endtask
endclass
```

**正确代码**
```systemverilog
covergroup cg;
    coverpoint addr;
    cross addr, data;
    
    option.per_instance = 1;
endsgroup

class my_monitor extends uvm_monitor;
    cg cg_inst;
    
    function void build_phase(uvm_phase phase);
        cg_inst = new();
    endtask
    
    task run_phase(uvm_phase phase);
        forever @ (posedge clk) begin
            // ...
            cg_inst.sample();  // 必须调用
        end
    endtask
endclass
```

---

## 调试技巧

### 1. 打印信息
```systemverilog
`uvm_info("TAG", $sformatf("value=%0d", value), UVM_LOW)
`uvm_warning("TAG", "message")
`uvm_error("TAG", "message")
`uvm_fatal("TAG", "message")
```

### 2. 打印对象
```systemverilog
req.print();  // 打印所有字段
```

### 3. 转储波形
```systemverilog
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
end
```

---

## 检查清单

提交代码前检查：

- [ ] 所有变量已初始化
- [ ] 数组索引不越界
- [ ] 阻塞/非阻塞赋值正确
- [ ] objection 配对使用
- [ ] config_db 检查返回值
- [ ] sequence item 已创建
- [ ] port 已连接
- [ ] coverage 有 sample()
- [ ] 没有死循环

