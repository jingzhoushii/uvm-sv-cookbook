// ============================================================================
// Full Isolation Check Example
// ============================================================================
`timescale 1ns/1ps
class iso_chk extends uvm_component; `uvm_component_utils(iso_chk) bit iso_en, din, dout;
    task run_phase(uvm_phase p); phase.raise_objection(this);
        forever begin #10; din=$urandom; if (!iso_en) dout = din ? 1'bz : 1'b0; else dout = din; $display("iso_en=%0d din=%0b dout=%0b",iso_en,din,dout); end phase.drop_objection(this);
    endtask
endclass
module tb_iso; initial begin iso_chk i; i=new("i",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_iso); end endmodule
