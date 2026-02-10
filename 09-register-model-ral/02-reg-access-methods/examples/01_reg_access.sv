// ============================================================================
// @file    : 01_reg_access.sv
// @brief   : 寄存器访问方法演示
// @note    : 展示 read/write/peek/poke
// ============================================================================

`timescale 1ns/1ps

class reg_model extends uvm_reg_block;
    uvm_reg ctrl;
    uvm_reg status;
    
    virtual function void build();
        ctrl = uvm_reg::type_id::create("ctrl");
        ctrl.build();
        ctrl.configure(this);
        
        status = uvm_reg::type_id::create("status");
        status.build();
        status.configure(this);
        
        default_map = create_map("map", 0, 4, UVM_LITTLE_ENDIAN);
        default_map.add_reg(ctrl, 'h0000, "RW");
        default_map.add_reg(status, 'h0004, "RO");
    endfunction
endclass

module tb_reg_access;
    initial begin
        $display("========================================");
        $display("  Register Access Methods Demo");
        $display("========================================");
        
        reg_model rm;
        rm = new();
        rm.build();
        rm.lock_model();
        
        // Write
        uvm_status_e status;
        uvm_reg_data_t data;
        
        data = 32'h1234_5678;
        rm.ctrl.write(status, data);
        $display("Write ctrl: 0x%0h", data);
        
        // Read
        rm.ctrl.read(status, data);
        $display("Read ctrl: 0x%0h", data);
        
        // Update
        rm.update(status);
        
        // Mirror
        rm.status.mirror(status, UVM_CHECK);
        
        #100;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_reg_access); end
endmodule
