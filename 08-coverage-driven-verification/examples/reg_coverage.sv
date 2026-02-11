// ============================================================================
// Register Coverage Example - 寄存器覆盖率示例
// ============================================================================

`include "uvm_macros.svh"

class bus_trans extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit is_read;
    
    `uvm_object_utils_begin(bus_trans)
        `uvm_field_int(addr, UVM_DEFAULT)
        `uvm_field_int(data, UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name="bus_trans");
        super.new(name);
    endfunction
endclass

// ==========================================
// 寄存器覆盖率收集器
// ==========================================
class reg_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(reg_coverage)
    
    // Mini SoC 地址映射
    localparam CPU_BASE = 'h0000_0000;
    localparam DMA_BASE = 'h1000_0000;
    localparam UART_BASE = 'h2000_0000;
    localparam TIMER_BASE = 'h3000_0000;
    
    covergroup soc_cg;
        // 模块访问覆盖
        MODULE: coverpoint tr.addr {
            bins CPU = {[CPU_BASE:CPU_BASE+'h0FF]};
            bins DMA = {[DMA_BASE:DMA_BASE+'h0FF]};
            bins UART = {[UART_BASE:UART_BASE+'h0FF]};
            bins TIMER = {[TIMER_BASE:TIMER_BASE+'h0FF]};
            bins MEM = {[CPU_BASE+'h100:$]};
        }
        
        // 读写覆盖
        RW: coverpoint tr.is_read {
            bins READ = {1};
            bins WRITE = {0};
        }
        
        // 寄存器访问交叉
        MODULE_RW: cross MODULE, RW {
            // CPU 读写平衡
            bins CPU_READ = binsof(MODULE.CPU) && binsof(RW.READ);
            bins CPU_WRITE = binsof(MODULE.CPU) && binsof(RW.WRITE);
        }
    endgroup
    
    // 统计
    int cpu_read = 0, cpu_write = 0;
    int dma_read = 0, dma_write = 0;
    int uart_read = 0, uart_write = 0;
    int timer_read = 0, timer_write = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        soc_cg = new();
    endfunction
    
    virtual function void write(T t);
        // 统计各模块访问
        if (t.addr inside {[CPU_BASE:CPU_BASE+'h0FF]}) begin
            if (t.is_read) cpu_read++; else cpu_write++;
        end else if (t.addr inside {[DMA_BASE:DMA_BASE+'h0FF]}) begin
            if (t.is_read) dma_read++; else dma_write++;
        end else if (t.addr inside {[UART_BASE:UART_BASE+'h0FF]}) begin
            if (t.is_read) uart_read++; else uart_write++;
        end else if (t.addr inside {[TIMER_BASE:TIMER_BASE+'h0FF]}) begin
            if (t.is_read) timer_read++; else timer_write++;
        end
        
        void'(soc_cg.sample());
    endfunction
    
    virtual function real get_coverage();
        return soc_cg.get_inst_coverage();
    endfunction
    
    virtual function void report();
        real cov = get_coverage();
        `uvm_info("REG_COV", 
            $sformatf("Overall Coverage: %0.1f%%", cov), UVM_LOW)
        `uvm_info("REG_COV", 
            $sformatf("CPU: R=%0d W=%0d", cpu_read, cpu_write), UVM_LOW)
        `uvm_info("REG_COV", 
            $sformatf("DMA: R=%0d W=%0d", dma_read, dma_write), UVM_LOW)
        `uvm_info("REG_COV", 
            $sformatf("UART: R=%0d W=%0d", uart_read, uart_write), UVM_LOW)
        `uvm_info("REG_COV", 
            $sformatf("TIMER: R=%0d W=%0d", timer_read, timer_write), UVM_LOW)
    endfunction
endclass

// ==========================================
// 环境
// ==========================================
class reg_env extends uvm_env;
    `uvm_component_utils(reg_env)
    
    reg_coverage cov;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        cov = reg_coverage::type_id::create("cov", this);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        cov.report();
    endfunction
endclass

// ==========================================
// Test
// ==========================================
class reg_test extends uvm_test;
    `uvm_component_utils(reg_test)
    
    reg_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        env = reg_env::type_id::create("env", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        bus_trans req;
        phase.raise_objection(this);
        
        // 模块化测试
        repeat(20) begin
            req = new();
            // CPU 访问
            req.addr = 'h0000 + $urandom_range(0, 15) * 4;
            req.is_read = $urandom();
            void'(env.cov.write(req));
            #5;
        end
        
        repeat(15) begin
            req = new();
            // DMA 访问
            req.addr = 'h1000 + $urandom_range(0, 15) * 4;
            req.is_read = $urandom();
            void'(env.cov.write(req));
            #5;
        end
        
        repeat(10) begin
            req = new();
            // UART 访问
            req.addr = 'h2000 + $urandom_range(0, 3) * 4;
            req.is_read = $urandom();
            void'(env.cov.write(req));
            #5;
        end
        
        repeat(10) begin
            req = new();
            // Timer 访问
            req.addr = 'h3000 + $urandom_range(0, 3) * 4;
            req.is_read = $urandom();
            void'(env.cov.write(req));
            #5;
        end
        
        phase.drop_objection(this);
    endtask
endclass

module tb_reg_coverage;
    initial begin
        run_test("reg_test");
    end
endmodule
