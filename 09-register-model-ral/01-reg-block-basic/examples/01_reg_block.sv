// ============================================================
// File: 01_reg_block.sv
// Description: RAL 寄存器模型示例
// ============================================================

`timescale 1ns/1ps

// 1. 寄存器定义
class ctrl_reg extends uvm_reg;
    uvm_reg_field enable;
    uvm_reg_field mode;
    uvm_reg_field reserved;
    
    function new(string name = "ctrl_reg");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
    
    virtual function void build();
        enable = uvm_reg_field::type_id::create("enable");
        enable.configure(this, 1, 0, "RW", 0, 1'b0, 1, 1, 0);
        
        mode = uvm_reg_field::type_id::create("mode");
        mode.configure(this, 2, 1, "RW", 0, 2'b00, 1, 1, 0);
        
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 29, 3, "RO", 0, 29'h0, 1, 0, 0);
    endfunction
endclass

class status_reg extends uvm_reg;
    uvm_reg_field busy;
    uvm_reg_field done;
    uvm_reg_field error;
    
    function new(string name = "status_reg");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
    
    virtual function void build();
        busy = uvm_reg_field::type_id::create("busy");
        busy.configure(this, 1, 0, "RO", 0, 1'b0, 1, 1, 0);
        
        done = uvm_reg_field::type_id::create("done");
        done.configure(this, 1, 1, "RC", 0, 1'b0, 1, 1, 0);
        
        error = uvm_reg_field::type_id::create("error");
        error.configure(this, 1, 2, "RC", 0, 1'b0, 1, 1, 0);
    endfunction
endclass

// 2. 寄存器块
class my_reg_block extends uvm_reg_block;
    ctrl_reg  ctrl;
    status_reg status;
    
    function new(string name = "my_reg_block");
        super.new(name);
    endfunction
    
    virtual function void build();
        ctrl = ctrl_reg::type_id::create("ctrl");
        ctrl.build();
        ctrl.configure(this);
        
        status = status_reg::type_id::create("status");
        status.build();
        status.configure(this);
        
        default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
        default_map.add_reg(ctrl, 'h0000, "RW");
        default_map.add_reg(status, 'h0004, "RO");
    endfunction
endclass

module tb_reg_block;
    
    my_reg_block reg_model;
    
    initial begin
        reg_model = new();
        reg_model.build();
        reg_model.lock_model();
        
        $display("========================================");
        $display("  RAL Register Block Demo");
        $display("========================================");
        $display("");
        
        // 打印寄存器
        reg_model.print();
        
        $display("");
        $display("--- Write/Read Test ---");
        reg_model.ctrl.enable.value = 1'b1;
        reg_model.ctrl.mode.value = 2'b10;
        $display("CTRL: enable=%0d mode=%0d", 
                 reg_model.ctrl.enable.value,
                 reg_model.ctrl.mode.value);
        
        $display("");
        $display("========================================");
        $display("  RAL Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_reg_block);
    end
    
endmodule
