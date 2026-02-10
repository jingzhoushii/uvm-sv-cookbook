`timescale 1ns/1ps
class my_rm extends uvm_reg_block;
    uvm_reg ctrl;
    covergroup cg;
        coverpoint ctrl.value[1:0] { bins mode[] = {0,1,2,3}; }
    endgroup
    virtual function void build();
        ctrl = uvm_reg::type_id::create("ctrl"); ctrl.build(); ctrl.configure(this);
        default_map = create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(ctrl,'h0,"RW");
        cg = new();
    endfunction
endclass
module tb; initial begin my_rm rm; rm=new(); rm.build(); rm.lock_model();
    rm.cg.sample(); rm.cg.sample(); $display("Coverage sampled"); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
