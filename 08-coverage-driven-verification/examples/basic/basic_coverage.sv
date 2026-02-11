// ============================================================================
// Basic Coverage Example - 覆盖率基础示例
// ============================================================================

`include "uvm_macros.svh"

// ==========================================
// 事务定义
// ==========================================
class bus_trans extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit is_read;
    rand bit [2:0] hsize;
    rand bit [2:0] hburst;
    
    `uvm_object_utils_begin(bus_trans)
        `uvm_field_int(addr, UVM_DEFAULT)
        `uvm_field_int(data, UVM_DEFAULT)
        `uvm_field_int(is_read, UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name="bus_trans");
        super.new(name);
    endfunction
endclass

// ==========================================
// 覆盖率收集器
// ==========================================
class bus_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(bus_coverage)
    
    // 覆盖率组
    covergroup cg;
        ADDR: coverpoint tr.addr {
            bins KB[] = {[0:'h1000]};
            bins MB[] = {['h1001:$]};
        }
        
        DATA: coverpoint tr.data {
            bins ZERO = {0};
            bins MAX = {'hFFFFFFFF};
            bins RAND = default;
        }
        
        RW: coverpoint tr.is_read {
            bins READ = {1};
            bins WRITE = {0};
        }
        
        SIZE: coverpoint tr.hsize {
            bins BYTE = {0};
            bins HALF = {1};
            bins WORD = {2};
        }
        
        // 交叉覆盖
        ADDR_RW: cross ADDR, RW;
    endgroup
    
    // 统计
    int trans_count = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction
    
    virtual function void write(T t);
        trans_count++;
        void'(cg.sample());
    endfunction
    
    virtual function real get_coverage();
        return cg.get_inst_coverage();
    endfunction
    
    virtual function void report();
        real cov = get_coverage();
        `uvm_info("COV", 
            $sformatf("Transactions: %0d, Coverage: %0.1f%%", 
                trans_count, cov), UVM_LOW)
    endfunction
endclass

// ==========================================
// 简单序列
// ==========================================
class basic_seq extends uvm_sequence#(bus_trans);
    `uvm_object_utils(basic_seq)
    
    int count = 50;
    
    virtual task body();
        repeat(count) begin
            bus_trans req;
            `uvm_create(req)
            req.randomize();
            `uvm_send(req)
            #10;
        end
    endtask
endclass

// ==========================================
// Driver
// ==========================================
class basic_driver extends uvm_driver#(bus_trans);
    `uvm_component_utils(basic_driver)
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("DRV", 
                $sformatf("Drive: addr=0x%0h data=0x%0h", 
                    req.addr, req.data), UVM_LOW)
            #5;
            seq_item_port.item_done();
        end
    endtask
endclass

// ==========================================
// Monitor
// ==========================================
class basic_monitor extends uvm_monitor;
    `uvm_component_utils(basic_monitor)
    
    uvm_analysis_port#(bus_trans) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            bus_trans req;
            #10;
            void'(ap.write(req));
        end
    endtask
endclass

// ==========================================
// Agent
// ==========================================
class basic_agent extends uvm_agent;
    `uvm_component_utils(basic_agent)
    
    basic_driver drv;
    basic_monitor mon;
    uvm_sequencer#(bus_trans) sqr;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        drv = basic_driver::type_id::create("drv", this);
        mon = basic_monitor::type_id::create("mon", this);
        sqr = uvm_sequencer#(bus_trans)::type_id::create("sqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

// ==========================================
// Environment
// ==========================================
class basic_env extends uvm_env;
    `uvm_component_utils(basic_env)
    
    basic_agent agent;
    bus_coverage cov;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        agent = basic_agent::type_id::create("agent", this);
        cov = bus_coverage::type_id::create("cov", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        agent.mon.ap.connect(cov.analysis_export);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        cov.report();
    endfunction
endclass

// ==========================================
// Test
// ==========================================
class basic_test extends uvm_test;
    `uvm_component_utils(basic_test)
    
    basic_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        env = basic_env::type_id::create("env", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        basic_seq seq;
        phase.raise_objection(this);
        seq = basic_seq::type_id::create("seq");
        seq.start(env.agent.sqr);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module tb_basic_coverage;
    initial begin
        run_test("basic_test");
    end
endmodule
