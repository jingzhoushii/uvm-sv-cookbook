// ============================================================================
// Power-On Sequence - 上电序列
// ============================================================================

`include "uvm_macros.svh"

class power_on_vseq extends uvm_sequence;
    `uvm_object_utils(power_on_vseq)
    
    soc_virtual_sequencer vseqr;
    
    virtual task body();
        `uvm_info("POWER_ON", "Starting power-on sequence", UVM_LOW)
        
        // 步骤 1: 配置 UART
        `uvm_info("POWER_ON", "Step 1: Configure UART", UVM_LOW)
        fork
            begin
                bus_trans req;
                `uvm_do_with(req, {is_read == 0; addr == 32'h2000_0008; data == 32'h0000_0001;})
            end
        join_none
        
        // 步骤 2: 配置 Timer
        `uvm_info("POWER_ON", "Step 2: Configure Timer", UVM_LOW)
        fork
            begin
                bus_trans req;
                `uvm_do_with(req, {is_read == 0; addr == 32'h3000_0008; data == 32'h0000_1000;})
            end
        join_none
        
        // 步骤 3: 配置 DMA
        `uvm_info("POWER_ON", "Step 3: Configure DMA", UVM_LOW)
        fork
            begin
                bus_trans req;
                `uvm_do_with(req, {is_read == 0; addr == 32'h1000_0000; data == 32'h0000_0001;})
            end
        join_none
        
        #100;
        `uvm_info("POWER_ON", "Power-on sequence complete", UVM_LOW)
    endtask
endclass

endmodule
