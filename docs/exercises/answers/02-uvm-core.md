# 📝 UVM 核心练习答案

## Level 1

### 练习 1：创建组件
```systemverilog
class my_comp extends uvm_component;
    `uvm_component_utils(my_comp)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // 构建代码
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // 连接代码
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        // 运行代码
        phase.drop_objection(this);
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        // 报告代码
    endfunction
endclass
```

### 练习 2：uvm_config_db
```systemverilog
// 设置端
class my_env extends uvm_env;
    virtual dut_if vif;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
            `uvm_error("NOVIF", "vif not found")
    endfunction
endclass

// 获取端
class my_driver extends uvm_driver;
    virtual dut_if vif;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
            `uvm_error("NOVIF", "vif not found")
    endfunction
endclass
```

### 练习 3：Objection
```systemverilog
virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);  // 必须配对
    `uvm_info("RUN", "Running...", UVM_LOW)
    #100;
    phase.drop_objection(this);    // 控制仿真时间
endtask
```

### 练习 4：Sequence Item
```systemverilog
class my_txn extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;
    
    `uvm_object_utils_begin(my_txn)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint basic { addr inside {[0:100]}; }
endclass
```

### 练习 5：Sequence
```systemverilog
class my_seq extends uvm_sequence#(my_txn);
    `uvm_object_utils(my_seq)
    
    int count = 10;
    
    virtual task body();
        repeat(count) begin
            my_txn tx;
            tx = my_txn::type_id::create("tx");
            start_item(tx);
            tx.randomize();
            finish_item(tx);
        end
    endtask
endclass
```

### 练习 6：Driver
```systemverilog
class my_driver extends uvm_driver#(my_txn);
    `uvm_component_utils(my_driver)
    
    virtual dut_if vif;
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            seq_item_port.get(req);
            drive(req);
            seq_item_port.item_done();
        end
        phase.drop_objection(this);
    endtask
    
    virtual protected task drive(my_txn tx);
        vif.addr = tx.addr;
        vif.data = tx.data;
        vif.rw = tx.rw;
        #10;
    endtask
endclass
```

### 练习 7：Monitor
```systemverilog
class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor)
    
    uvm_analysis_port#(my_txn) ap;
    virtual dut_if vif;
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if (vif.valid) begin
                my_txn tx;
                tx = my_txn::type_id::create("tx");
                tx.addr = vif.addr;
                tx.data = vif.data;
                tx.rw = vif.rw;
                ap.write(tx);
            end
        end
    endtask
endclass
```

### 练习 8：Agent
```systemverilog
class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    my_driver    drv;
    my_monitor   mon;
    my_sequencer sqr;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = my_driver::type_id::create("drv", this);
        mon = my_monitor::type_id::create("mon", this);
        sqr = my_sequencer::type_id::create("sqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.ap.connect(some_port);
    endfunction
endclass
```

### 练习 9：Analysis Port
```systemverilog
// 发送端
class my_monitor extends uvm_monitor;
    uvm_analysis_port#(my_txn) ap;
    
    function new(...);
        ap = new("ap", this);
    endtask
endclass

// 接收端
class my_subscriber extends uvm_subscriber#(my_txn);
    uvm_analysis_imp#(my_txn, my_subscriber) imp;
    
    function new(...);
        imp = new("imp", this);
    endfunction
    
    virtual function void write(my_txn t);
        `uvm_info("SUB", $sformatf("Got: addr=0x%0h", t.addr), UVM_LOW)
    endfunction
endclass
```

### 练习 10：Environment
```systemverilog
class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    
    my_agent agent;
    my_scoreboard sb;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = my_agent::type_id::create("agent", this);
        sb = my_scoreboard::type_id::create("sb", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.ap.connect(sb.analysis_export);
    endfunction
endclass
```

