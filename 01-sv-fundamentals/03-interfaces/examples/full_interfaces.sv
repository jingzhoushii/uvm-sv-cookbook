// ============================================================================
// Full SystemVerilog Interfaces Example
// ============================================================================
`timescale 1ns/1ps
interface bus_if (input bit clk);
    logic [31:0] addr; logic [31:0] data; logic rw; logic valid; logic ready;
    modport master (output addr,data,rw,valid, input ready);
    modport slave (input addr,data,rw,valid, output ready);
    task master_write(input [31:0] a, d); addr=a; data=d; rw=1; valid=1; @(posedge clk); while(!ready) @(posedge clk); valid=0; endtask
endinterface

module tb_if;
    bit clk; bus_if ifc(clk);
    initial begin clk=0; forever #5 clk=~clk; end
    initial begin ifc.master_write(32'h1000,32'hABCD); #100; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_if); end endmodule
