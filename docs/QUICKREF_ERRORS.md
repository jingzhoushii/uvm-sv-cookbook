# ⚠️ 常见错误速查表

快速诊断和修复 SystemVerilog/UVM 常见错误。

---

## 编译错误

### ❌ Error: 'super' is not a valid type

**原因**: 在类外部使用了 `super`

**错误代码**
```systemverilog
super.new();  // ❌ 在类外部
```

**正确代码**
```systemverilog
class my_class;
    function new();
        super.new();  // ✅ 在类内部
    endfunction
endclass
```

---

### ❌ Error: Undefined variable: xxx

**原因**: 变量未声明或拼写错误

**错误代码**
```systemverilog
initial begin
    counr = 5;  // ❌ 拼写错误
end
```

**正确代码**
```systemverilog
initial begin
    int count = 5;  // ✅ 正确声明
end
```

---

### ❌ Error: Range must be integral

**原因**: 数组索引不是整数

**错误代码**
```systemverilog
bit [7:0] arr[4];
arr[1.5] = 8'hFF;  // ❌ 浮点数索引
```

**正确代码**
```systemverilog
bit [7:0] arr[4];
arr[1] = 8'hFF;  // ✅ 整数索引
```

---

### ❌ Error: Assignment to implicit port xxx

**原因**: 模块端口未正确连接

**错误代码**
```systemverilog
module top;
    dut u (.clk(clk));  // ❌ 端口名不匹配
endmodule
```

**正确代码**
```systemverilog
module top;
    wire clk;
    dut u (.clk(clk));  // ✅ 端口名匹配
endmodule
```

---

## UVM 运行时错误

### ❌ UVM_FATAL @ report_phase: No such object

**原因**: 组件未正确创建

**错误代码**
```systemverilog
class my_driver extends uvm_driver;
    virtual task run_phase(uvm_phase phase);
        seq_item_port.get(req);  // ❌ req 未创建
    endtask
endclass
```

**正确代码**
```systemverilog
class my_driver extends uvm_driver;
    virtual task run_phase(uvm_phase phase);
        seq_item_port.get(req);
        // req 在 sequence 中创建
    endtask
endclass
```

---

### ❌ UVM_FATAL: Object not created by factory

**原因**: 未使用 factory 创建对象

**错误代码**
```systemverilog
my_driver d = new();  // ❌ 直接使用 new
```

**正确代码**
```systemverilog
my_driver d = my_driver::type_id::create("d", this);  // ✅ factory
```

---

### ❌ Objection not raised

**原因**: run_phase 中未提起 objection

**错误代码**
```systemverilog
task run_phase(uvm_phase phase);
    #100;  // ❌ 仿真立即结束
endtask
```

**正确代码**
```systemverilog
task run_phase(uvm_phase phase);
    phase.raise_objection(this);  // ✅ 提起
    #100;
    phase.drop_objection(this);    // ✅ 放下
endtask
```

---

## 仿真问题

### ❌ 仿真挂起

**可能原因**: 
1. objection 未放下
2. 死循环
3. 邮箱/信号量未正确使用

**调试方法**
```systemverilog
// 添加超时
task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
        begin
            #10000;  // 10us 超时
            `uvm_error("TIMEOUT", "Simulation timeout!")
            phase.drop_objection(this);
        end
    join_none
join
endtask
```

---

### ❌ 数据不一致

**可能原因**: Analysis Port 直接修改 broadcast 数据

**调试方法**
```systemverilog
// ✅ 始终先复制
virtual function void write(trans t);
    trans local_t;
    local_t.copy(t);  // 先复制
    // 再修改 local_t
endfunction
```

---

## 波形查看

### ❌ 看不到信号

**原因**: 未启用波形记录

**解决方法**
```systemverilog
initial begin
    $dumpfile("dump.vcd");     // ✅ 指定文件
    $dumpvars(0, top_module);   // ✅ 记录信号
end
```

---

## 快速检查清单

提交代码前检查：

- [ ] 所有变量已声明
- [ ] 类外部未使用 `super`
- [ ] 数组索引为整数
- [ ] 模块端口名匹配
- [ ] objection 配对使用
- [ ] factory 创建对象
- [ ] 启用波形记录
- [ ] analysis port 使用 copy

