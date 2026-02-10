// ============================================================================
// Full SystemVerilog Randomization Example
// ============================================================================
`timescale 1ns/1ps
class tx; rand bit [7:0] d; rand bit [3:0] len; constraint c1 { d inside {[10:100]}; len inside {[1:10]}; }
    constraint c2 { d > 50 -> len < 5; } constraint c3 { len dist {0:/10, 1:/30, 2:/60}; }
endclass
module tb_rnd; initial begin tx t; repeat(5) begin t=new(); void'(t.randomize()); $display("d=%0d len=%0d",t.d,t.len); end #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_rnd); end endmodule
