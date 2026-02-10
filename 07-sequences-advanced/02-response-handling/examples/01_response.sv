// ============================================================================
// @file    : 01_response.sv
// @brief   : Response 处理演示
// @note    : 展示序列响应机制
// ============================================================================

`timescale 1ns/1ps

class my_txn extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    `uvm_object_utils_begin(my_txn)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// 产生响应的 Driver
class resp_driver extends uvm_driver#(my_txn, my_txn);
    `uvm_component_utils(resp_driver)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        forever begin
            seq_item_port.get(req);
            
            $display("[%0t] [%s] Received: addr=0x%0h data=0x%0h", 
                     $time, get_full_name(), req.addr, req.data);
            
            // 模拟延迟
            #10;
            
            // 生成响应
            my_txn rsp;
            rsp = my_txn::type_id::create("rsp");
            rsp.set_id_info(req);  // 设置 ID 信息
            rsp.addr = req.addr;
            rsp.data = req.data + 1;  // 响应数据 +1
            
            seq_item_port.put_response(rsp);
            
            $display("[%0t] [%s] Sent response: data=0x%0h", 
                     $time, get_full_name(), rsp.data);
        end
        
        phase.drop_objection(this);
    endtask
endclass

// 接收响应的 Sequencer
class my_sequencer extends uvm_sequencer#(my_txn, my_txn);
    `uvm_component_utils(my_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// 发送请求并接收响应的序列
class req_resp_sequence extends uvm_sequence#(my_txn, my_txn);
    `uvm_object_utils(req_resp_sequence)
    
    int req_count;
    int rsp_count;
    
    function new(string name = "req_resp_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        `uvm_info(get_type_name(), "Starting sequence", UVM_LOW)
        
        repeat (5) begin
            my_txn req, rsp;
            
            // 发送请求
            req = my_txn::type_id::create("req");
            start_item(req);
            void'(req.randomize() with { addr inside {[0:100]}; });
            `uvm_info(get_type_name(), 
                $sformatf("Send request: addr=0x%0h", req.addr), UVM_LOW)
            finish_item(req);
            req_count++;
            
            // 获取响应
            get_response(rsp);
            rsp_count++;
            `uvm_info(get_type_name(), 
                $sformatf("Got response: addr=0x%0h data=0x%0h", 
                         rsp.addr, rsp.data), UVM_LOW)
        end
        
        `uvm_info(get_type_name(), 
            $sformatf("Done: req=%0d rsp=%0d", req_count, rsp_count), 
            UVM_LOW)
    endtask
endclass

module tb_response;
    
    initial begin
        $display("========================================");
        $display("  Response Handling Demo");
        $display("========================================");
        $display("");
        
        my_sequencer sqr;
        resp_driver drv;
        
        sqr = my_sequencer::type_id::create("sqr", null);
        drv = resp_driver::type_id::create("drv", null);
        
        // 连接
        drv.seq_item_port.connect(sqr.seq_item_export);
        
        // 启动序列
        req_resp_sequence seq;
        seq = req_resp_sequence::type_id::create("seq");
        
        fork
            seq.start(sqr);
        join_none
        
        #200;
        
        $display("");
        $display("========================================");
        $display("  Response Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_response);
    end
    
endmodule
