// ============================================================================
// @file    : 01_reg_sequence.sv
// @brief   : 寄存器序列演示
// @note    : 展示 uvm_reg_sequence
// ============================================================================

`timescale 1ns/1ps

class reg_block extends uvm_reg_block;
    uvm_reg ctrl;
    virtual function void build();
        ctrl = uvm_reg::type_id::create("ctrl");
        ctrl.build();
        ctrl.configure(this);
        default_map = create_map("map", 0, 4, UVM_LITTLE_ENDIAN);
        default_map.add_reg(ctrl, 'h0000, "RW");
    endfunction
endclass

class reg_test_seq extends uvm_reg_sequence;
    `uvm_object_utils(reg_test_seq)
    
    reg_block rm;
    
    task body();
        uvm_reg_data_t data;
        
        // 写寄存器
        write_reg(rm.ctrl, .value(32'hAAAA_0000));
        
        // 读寄存器
        read_reg(rm.ctrl, .value(data));
        `uvm_info("REG", $sformatf("Read: 0x%0h", data), UVM_LOW)
        
        // 更新
        update_reg(rm.ctrl);
        
        // 镜像
        mirror_reg(rm.ctrl, UVM_CHECK);
    endtask
endclass

module tb_reg_sequence;
    initial begin
        $display("========================================");
        $display("  Register Sequences Demo");
        $display("========================================");
        
        reg_block rm;
        rm = new();
        rm.build();
        rm.lock_model();
        
        reg_test_seq seq;
        seq = new("seq");
        seq.rm = rm;
        seq.start(null);
        
        #100;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_reg_sequence); end
endmodule
