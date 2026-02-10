// ============================================================================
// @file    : 01_analysis_port.sv
// @brief   : Analysis Port 演示
// @note    : 一对多通信模式
// ============================================================================

`timescale 1ns/1ps

class transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// Producer - 产生事务
class producer extends uvm_component;
    `uvm_component_utils(producer)
    uvm_analysis_port#(transaction) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        repeat (5) begin
            transaction tr;
            tr = transaction::type_id::create("tr");
            void'(tr.randomize());
            
            $display("[%0t] [%s] Write: addr=0x%0h data=0x%0h", 
                     $time, get_full_name(), tr.addr, tr.data);
            
            // 广播到所有连接的分析端口
            ap.write(tr);
            
            #10;
        end
        
        phase.drop_objection(this);
    endtask
endclass

// Consumer A - 消费者 A
class consumer_a extends uvm_component;
    `uvm_component_utils(consumer_a)
    uvm_analysis_imp#(transaction, consumer_a) imp;
    int count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
        count = 0;
    endfunction
    
    virtual function void write(transaction tr);
        count++;
        $display("[%0t] [%s] ConsumerA Received #%0d: addr=0x%0h", 
                 $time, get_full_name(), count, tr.addr);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

// Consumer B - 消费者 B
class consumer_b extends uvm_component;
    `uvm_component_utils(consumer_b)
    uvm_analysis_imp#(transaction, consumer_b) imp;
    int count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
        count = 0;
    endfunction
    
    virtual function void write(transaction tr);
        count++;
        $display("[%0t] [%s] ConsumerB Received #%0d: data=0x%0h", 
                 $time, get_full_name(), count, tr.data);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

// 环境 - 连接所有组件
class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    
    producer  prod;
    consumer_a cons_a;
    consumer_b cons_b;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        prod = producer::type_id::create("prod", this);
        cons_a = consumer_a::type_id::create("cons_a", this);
        cons_b = consumer_b::type_id::create("cons_b", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // 【核心】连接 analysis port 到多个 imp
        prod.ap.connect(cons_a.imp);
        prod.ap.connect(cons_b.imp);
        
        $display("[%0t] [%s] Connected prod.ap -> cons_a and cons_b", 
                 $time, get_full_name());
    endfunction
endclass

module tb_analysis_port;
    
    initial begin
        $display("========================================");
        $display("  Analysis Port Demo");
        $display("========================================");
        $display("");
        
        my_env env;
        env = my_env::type_id::create("env", null);
        
        #200;
        
        $display("");
        $display("========================================");
        $display("  Analysis Port Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_analysis_port);
    end
    
endmodule
