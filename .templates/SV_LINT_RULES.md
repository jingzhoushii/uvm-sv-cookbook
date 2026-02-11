# SystemVerilog 编码规范

## 命名规范

### 文件命名
- 使用小写字母和下划线
- 示例: `my_driver.sv`, `axi_agent.sv`

### 类命名
- 使用 CamelCase
- 示例: `MyDriver`, `AxiAgent`

### 变量命名
- 使用小写下划线
- 示例: `packet_count`, `data_bus`

### 常量命名
- 使用全大写下划线
- 示例: `MAX_COUNT`, `DEFAULT_DELAY`

## 编码规范

### 模块定义
```systemverilog
// ✅ 正确：清晰的端口声明
module my_module (
    input  bit clk,
    input  bit rst_n,
    output bit [31:0] data
);
    // ...
endmodule
```

### 类定义
```systemverilog
// ✅ 正确：包含 uvm_object_utils
class my_class extends uvm_object;
    `uvm_object_utils_begin(my_class)
    `uvm_field_int(count, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name="my_class");
        super.new(name);
    endfunction
endclass
```

### 注释规范
```systemverilog
// 单行注释（前面有空格）
if (condition) begin  // 条件说明
    // 多行注释
    // 这是多行注释
    // 的第二行
end
```

### 缩进
- 使用 4 空格缩进
- 不使用 Tab

## 常见错误

### ❌ 禁止：直接修改 broadcast 的 transaction
```systemverilog
// 错误
virtual function void write(trans t);
    t.addr = 8'hFF;  // 污染原始数据
endfunction

// 正确
virtual function void write(trans t);
    trans local_t;
    local_t.copy(t);  // 先复制
    local_t.addr = 8'hFF;  // 修改副本
endfunction
```

### ❌ 禁止：使用静态变量（除非必要）
```systemverilog
// 错误
class bad;
    static int count;  // 所有实例共享
endclass

// 正确
class good;
    int count;  // 每个实例独立
endclass
```

### ❌ 禁止：忘记 objection
```systemverilog
// 错误
task run_phase(uvm_phase phase);
    forever begin
        #100;  // 仿真挂起
    end
endtask

// 正确
task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    forever begin
        #100;
    end
    phase.drop_objection(this);
endtask
```

