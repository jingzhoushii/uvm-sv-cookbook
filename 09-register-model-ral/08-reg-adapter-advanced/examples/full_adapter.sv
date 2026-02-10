// ============================================================================
// Full RAL Adapter Advanced Example
// ============================================================================
`timescale 1ns/1ps
class adp extends uvm_reg_adapter; `uvm_object_utils(adp)
    function new(string n="adp"); super.new(n); endfunction
    function void reg2bus(uvm_reg_bus_op r); r.kind=(r.kind==UVM_READ)?"READ":"WRITE"; endfunction
    function void bus2reg(uvm_reg_bus_op r, uvm_reg_data_t d); r.kind=(r.kind=="READ")?UVM_READ:UVM_WRITE; r.data=d; r.status=UVM_IS_OK; endfunction
endclass
module tb_ad; initial begin adp a; a=new(); $display("Adapter created"); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_ad); end endmodule
