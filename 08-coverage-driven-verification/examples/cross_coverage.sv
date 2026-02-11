// ============================================================================
// Cross Coverage Example - 交叉覆盖率示例
// ============================================================================

`include "uvm_macros.svh"

class bus_trans extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit is_read;
    rand bit [2:0] size;
    rand bit [2:0] burst;
    
    `uvm_object_utils_begin(bus_trans)
        `uvm_field_int(addr, UVM_DEFAULT)
        `uvm_field_int(data, UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name="bus_trans");
        super.new(name);
    endfunction
endclass

// ==========================================
// 交叉覆盖率收集器
// ==========================================
class cross_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(cross_coverage)
    
    covergroup cg;
        // 地址覆盖 - 按模块
        ADDR: coverpoint tr.addr {
            bins CPU = {[0:'h00FF]};
            bins DMA = {['h0100:'h04FF]};
            bins UART = {['h0500:'h08FF]};
            bins TIMER = {['h0900:'h0FFF]};
            bins MEM = {['h1000:$]};
        }
        
        // 数据大小
        SIZE: coverpoint tr.size {
            bins BYTE = {0};
            bins HALF = {1};
            bins WORD = {2};
        }
        
        // 突发类型
        BURST: coverpoint tr.burst {
            bins SINGLE = {0};
            bins INCR = {1};
            bins WRAP = {2};
        }
        
        // 读写
        RW: coverpoint tr.is_read {
            bins READ = {1};
            bins WRITE = {0};
        }
        
        // 交叉覆盖
        ADDR_SIZE: cross ADDR, SIZE;
        ADDR_BURST: cross ADDR, BURST;
        ADDR_RW: cross ADDR, RW;
        SIZE_BURST: cross SIZE, BURST;
        FULL: cross ADDR, RW, SIZE;
    endgroup
    
    // 统计
    int total_trans = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction
    
    virtual function void write(T t);
        total_trans++;
        void'(cg.sample());
    endfunction
    
    virtual function real get_coverage();
        return cg.get_inst_coverage();
    endfunction
    
    virtual function void report();
        real cov = get_coverage();
        `uvm_info("CROSS_COV", 
            $sformatf("Total: %0d, Coverage: %0.1f%%", 
                total_trans, cov), UVM_LOW)
        
        // 打印覆盖组细节
        `uvm_info("CROSS_COV", 
            $sformatf("ADDR coverage: %0.1f%%", 
                cg.ADDR.get_coverage()), UVM_LOW)
        `uvm_info("CROSS_COV", 
            $sformatf("SIZE coverage: %0.1f%%", 
                cg.SIZE.get_coverage()), UVM_LOW)
    endfunction
endclass

// ==========================================
// 环境
// ==========================================
class cross_env extends uvm_env;
    `uvm_component_utils(cross_env)
    
    cross_coverage cov;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        cov = cross_coverage::type_id::create("cov", this);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        cov.report();
    endfunction
endclass

// ==========================================
// Test
// ==========================================
class cross_test extends uvm_test;
    `uvm_component_utils(cross_test)
    
    cross_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        env = cross_env::type_id::create("env", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        bus_trans req;
        phase.raise_objection(this);
        
        // 随机测试
        repeat(100) begin
            void'(env.cov.write(req));
            #5;
        end
        
        // 定向测试 - 填充空白
        for (int i = 0; i < 5; i++) begin
            req = new();
            req.addr = 'h0050 + i*'h100;
            req.size = i % 3;
            req.burst = i % 3;
            req.is_read = i % 2;
            void'(env.cov.write(req));
            #5;
        end
        
        phase.drop_objection(this);
    endtask
endclass

module tb_cross_coverage;
    initial begin
        run_test("cross_test");
    end
endmodule
