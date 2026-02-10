`timescale 1ns/1ps
class bus_adapter extends uvm_reg_adapter;
    `uvm_object_utils(bus_adapter)
    function new(string n="bus_adapter"); super.new(n); endfunction
    virtual function void reg2bus(uvm_reg_bus_op rw);
        rw.kind = (rw.kind==UVM_READ)?"READ":"WRITE";
    endfunction
    virtual function void bus2reg(uvm_reg_bus_op rw, uvm_reg_data_t data);
        rw.kind = (rw.kind=="READ")?UVM_READ:UVM_WRITE;
        rw.data = data; rw.status = UVM_IS_OK;
    endfunction
endclass
module tb; initial begin bus_adapter ada; ada=new(); $display("Adapter created"); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
