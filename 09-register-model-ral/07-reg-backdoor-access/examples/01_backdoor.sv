`timescale 1ns/1ps
class my_rm extends uvm_reg_block;
    uvm_reg ctrl;
    virtual function void build();
        ctrl = uvm_reg::type_id::create("ctrl"); ctrl.build();
        ctrl.add_hdl_path("tb.dut.ctrl");
        ctrl.configure(this);
        default_map = create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(ctrl,'h0,"RW");
    endfunction
endclass
module tb; reg[31:0] ctrl=0; initial begin my_rm rm; rm=new(); rm.build(); rm.lock_model();
    uvm_reg_data_t d; rm.ctrl.poke(status,32'hABCD); rm.ctrl.peek(status,d);
    $display("Backdoor poke/peek: d=0x%0h",d); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
