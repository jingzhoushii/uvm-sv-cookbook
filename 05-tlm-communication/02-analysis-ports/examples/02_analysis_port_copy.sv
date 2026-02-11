// ============================================================================
// UVM Analysis Port - 常见错误演示
// ============================================================================
// ⚠️ 本文件演示一个严重错误：修改 broadcast 的 transaction
// ============================================================================

`timescale 1ns/1ps

class trans extends uvm_sequence_item;
    rand bit [7:0] addr;
    rand bit [7:0] data;
    `uvm_object_utils_begin(trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// ============================================================================
// ❌ 错误示例：直接修改 broadcast 的 transaction
// 严重问题：会污染其他 subscriber 的数据！
// ============================================================================
class bad_subscriber extends uvm_subscriber#(trans);
    `uvm_component_utils(bad_subscriber)
    
    virtual function void write(trans t);
        // ⚠️ 错误！直接修改会导致其他 subscriber 看到脏数据
        $display("[Bad] 修改前: addr=0x%0h data=0x%0h", t.addr, t.data);
        t.addr = 8'hFF;  // ❌ 这会污染原始数据！
        t.data = 8'h00;
        $display("[Bad] 修改后: addr=0x%0h data=0x%0h", t.addr, t.data);
    endfunction
endclass

// ============================================================================
// ✅ 正确示例：先复制再修改
// ============================================================================
class good_subscriber extends uvm_subscriber#(trans);
    `uvm_component_utils(good_subscriber)
    
    virtual function void write(trans t);
        // ✅ 正确：先复制，再修改副本
        trans local_t = trans::type_id::create("local_t");
        local_t.copy(t);  // 复制原始数据
        
        // 现在可以安全修改
        $display("[Good] 原始: addr=0x%0h data=0x%0h", t.addr, t.data);
        local_t.addr = 8'hFF;  // 修改副本
        local_t.data = 8'h00;
        $display("[Good] 修改副本: addr=0x%0h data=0x%0h", local_t.addr, local_t.data);
        // 原始 t 保持不变！
    endfunction
endclass

// ============================================================================
// Monitor（产生 transaction）
// ============================================================================
class monitor extends uvm_component;
    `uvm_component_utils(monitor)
    
    uvm_analysis_port#(trans) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        repeat(3) begin
            trans t;
            t = trans::type_id::create("t");
            t.randomize();
            $display("\n[Monitor] 产生: addr=0x%0h data=0x%0h", t.addr, t.data);
            ap.write(t);  // 广播给所有 subscriber
            #10;
        end
        phase.drop_objection(this);
    endtask
endclass

// ============================================================================
// 环境：连接多个 subscriber
// ============================================================================
class env extends uvm_env;
    `uvm_component_utils(env)
    
    monitor mon;
    bad_subscriber  bad1;
    good_subscriber good1;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = monitor::type_id::create("mon", this);
        bad1 = bad_subscriber::type_id::create("bad1", this);
        good1 = good_subscriber::type_id::create("good1", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.ap.connect(bad1.analysis_export);
        mon.ap.connect(good1.analysis_export);
    endfunction
endclass

// ============================================================================
// 测试
// ============================================================================
module tb_analysis_port;
    initial begin
        env e;
        
        $display("========================================");
        $display("  Analysis Port 错误演示");
        $display("========================================");
        
        e = env::type_id::create("e", null);
        e.build();
        e.connect();
        
        run_test();
        
        $display("\n========================================");
        $display("  关键教训");
        $display("========================================");
        $display("❌ 不要修改 broadcast 的 transaction");
        $display("✅ 先 copy() 再修改");
        $display("========================================");
        
        #100;
        $finish;
    end
endmodule
