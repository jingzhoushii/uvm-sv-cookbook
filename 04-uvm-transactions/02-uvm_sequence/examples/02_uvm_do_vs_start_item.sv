// ============================================================================
// UVM Sequence: uvm_do vs start_item/finish_item 对比
// ============================================================================
// 本文件演示两种序列方法的优缺点
// ============================================================================

`timescale 1ns/1ps

// Transaction 定义
class my_txn extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;
    
    `uvm_object_utils_begin(my_txn)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// ============================================================================
// 方法 1: 使用 uvm_do 宏（简洁，但隐藏细节）
// 优点：代码简洁，一行完成创建+随机+发送
// 缺点：不够灵活，无法多次 randomize
// ============================================================================
class seq_using_uvm_do extends uvm_sequence#(my_txn);
    `uvm_object_utils(seq_using_uvm_do)
    
    int count = 5;
    
    virtual task body();
        repeat(count) begin
            // ✅ 简洁：一行搞定
            `uvm_do(req)  // 自动创建+随机+发送
            $display("[uvm_do] sent txn: addr=0x%0h data=0x%0h", req.addr, req.data);
        end
    endtask
endclass

// ============================================================================
// 方法 2: 使用 start_item/finish_item（灵活，可控性强）
// 优点：完全控制，可以多次 randomize
// 缺点：代码较多
// ============================================================================
class seq_using_start_item extends uvm_sequence#(my_txn);
    `uvm_object_utils(seq_using_start_item)
    
    int count = 5;
    
    virtual task body();
        repeat(count) begin
            // ✅ 灵活：可以多次 randomize
            req = my_txn::type_id::create("req");
            start_item(req);           // 准备发送
            
            // 可以在这里做额外操作
            if (!req.randomize() with { addr < 100; }) begin
                `uvm_error("RND", "Randomize failed")
            end
            
            // 如果需要，可以再次随机
            // req.randomize() with { data > 50; };
            
            finish_item(req);          // 完成发送
            
            $display("[start_item] sent txn: addr=0x%0h data=0x%0h", req.addr, req.data);
        end
    endtask
endclass

// ============================================================================
// Driver（演示接收）
// ============================================================================
class my_driver extends uvm_driver#(my_txn);
    `uvm_component_utils(my_driver)
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            seq_item_port.get(req);
            $display("[Driver] received: addr=0x%0h data=0x%0h", req.addr, req.data);
            #10;
        end
        phase.drop_objection(this);
    endtask
endclass

// ============================================================================
// 环境
// ============================================================================
class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    
    my_driver drv;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = my_driver::type_id::create("drv", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
endclass

// ============================================================================
// 测试
// ============================================================================
module tb_seq_methods;
    initial begin
        my_env env;
        seq_using_uvm_do seq1;
        seq_using_start_item seq2;
        
        $display("========================================");
        $display("  uvm_do vs start_item/finish_item");
        $display("========================================");
        
        // 测试 uvm_do
        $display("\n--- 方法 1: uvm_do ---");
        env = new("env");
        env.build();
        
        // 运行序列
        seq1 = seq_using_uvm_do::type_id::create("seq1");
        seq1.start(env.drv.seqr);
        
        $display("\n========================================");
        $display("  对比总结");
        $display("========================================");
        $display("uvm_do: 简洁，适合入门");
        $display("start_item: 灵活，适合高级场景");
        $display("========================================");
        
        #100;
        $finish;
    end
endmodule
