# 📝 SV 基础练习答案

## Level 1

### 练习 1：数据类型转换
```systemverilog
int i = 100;
bit [7:0] b;
logic [7:0] l;

b = i[7:0];      // 转换为 bit
l = i[7:0];      // 转换为 logic
```

### 练习 2：数组操作
```systemverilog
int dyn[];
initial begin
    dyn = new[10];           // 分配 10 个元素
    foreach (dyn[i])         // 随机填充
        dyn[i] = $urandom;
    dyn.sort();              // 排序
    foreach (dyn[i])
        $display("dyn[%0d]=%0d", i, dyn[i]);
end
```

### 练习 3：结构体
```systemverilog
typedef struct {
    bit [31:0] addr;
    bit [31:0] data;
    bit        rw;
    time       timestamp;
} bus_transaction_t;
```

### 练习 4：枚举
```systemverilog
typedef enum {IDLE, READ, WRITE} state_e;
state_e state = IDLE;
```

### 练习 5：类继承
```systemverilog
class animal;
    string name;
    function new(string n);
        name = n;
    endfunction
    virtual function void speak();
        $display("Animal sound");
    endfunction
endclass

class dog extends animal;
    function new(string n);
        super.new(n);
    endfunction
    function void speak();
        $display("Woof!");
    endfunction
endclass
```

## Level 2

### 练习 6：随机化约束
```systemverilog
class tx;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;
    
    constraint addr_range {
        addr inside {[0:100]};
        data != 0;
        data != 32'hFFFF_FFFF;
    }
    
    constraint rw_ratio {
        rw dist {0:/1, 1:/2};  // read:write = 1:2
    }
endclass
```

### 练习 7：覆盖率
```systemverilog
covergroup cg;
    coverpoint addr { bins addr_range[] = {[0:100]}; }
    coverpoint data { bins data_range[] = {[0:255]]; }
    cross addr, data;
endgroup
```

### 练习 8：Mailbox
```systemverilog
class producer;
    mailbox #(int) mb;
    function new(mailbox #(int) m);
        mb = m;
    endfunction
    task run();
        for(int i=0; i<5; i++) begin
            mb.put(i);
            $display("Put: %0d", i);
        end
    endtask
endclass

class consumer;
    mailbox #(int) mb;
    function new(mailbox #(int) m);
        mb = m;
    endfunction
    task run();
        int val;
        for(int i=0; i<5; i++) begin
            mb.get(val);
            $display("Got: %0d", val);
        end
    endtask
endclass
```

### 练习 9：Semaphore
```systemverilog
semaphore sm = new(2);  // 2 个资源

task thread1();
    sm.get(1);
    // 使用资源
    #10;
    sm.put(1);
endtask
```

### 练习 10：Interface
```systemverilog
interface bus_if (input clk, input rst);
    logic [31:0] addr;
    logic [31:0] data;
    logic        rw;
    logic        valid;
    logic        ready;
    
    modport master (output addr, data, rw, valid, input ready);
    modport slave  (input addr, data, rw, valid, output ready);
endinterface
```

