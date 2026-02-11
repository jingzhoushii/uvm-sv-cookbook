// ============================================================================
// Enhanced Boot Virtual Sequence - 增强引导序列
// ============================================================================

`include "uvm_macros.svh"
`include "base_vseq.sv"

class boot_vseq_enh extends base_vseq;
    `uvm_object_utils(boot_vseq_enh)
    
    // 引导步骤
    bit [31:0] boot_addr = 32'h0000_0000;
    int boot_count = 10;
    
    virtual task body();
        `uvm_info("BOOT", "Starting enhanced boot sequence", UVM_LOW)
        
        // 步骤 1: 配置 UART
        `uvm_info("BOOT", "Step 1: Configure UART", UVM_LOW)
        begin
            bus_trans req;
            `uvm_do_with(req, {
                req.is_read = 0;
                req.addr = 32'h2000_0000;  // UART 基地址
                req.data = 32'h0000_0001;  // 启用 UART
            })
        end
        
        // 步骤 2: 配置 Timer
        `uvm_info("BOOT", "Step 2: Configure Timer", UVM_LOW)
        begin
            bus_trans req;
            `uvm_do_with(req, {
                req.is_read = 0;
                req.addr = 32'h3000_0000;  // Timer 基地址
                req.data = 32'h0000_1000;  // 设置初始值
            })
        end
        
        // 步骤 3: 读取 CPU Stub
        `uvm_info("BOOT", "Step 3: Test CPU Stub", UVM_LOW)
        repeat(boot_count) begin
            bus_trans req;
            `uvm_do_with(req, {
                req.is_read = 1;
                req.addr = boot_addr;
            })
        end
        
        `uvm_info("BOOT", "Boot sequence complete", UVM_LOW)
    endtask
endclass

endmodule
