`timescale 1ns/1ps
class my_rm extends uvm_reg_block;
    uvm_reg ctrl;
    virtual function void build();
        ctrl = uvm_reg::type_id::create("ctrl"); ctrl.build();
        ctrl.add_hdl_path("tb.dut.ctrl");
        ctrl.configure(this,0,'h1234_5678); // 复位值
        default_map = create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(ctrl,'h0,"RW");
    endfunction
endclass
module tb; reg[31:0] ctrl=32'h1234_5678; initial begin my_rm rm; rm=new(); rm.build(); rm.lock_model();
    uvm_reg_data_t d; rm.ctrl.mirror(status,UVM_CHECK);
    $display("Reset value checked"); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
