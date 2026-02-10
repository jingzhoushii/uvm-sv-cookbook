// ============================================================================
// Full SystemVerilog OOP Example
// ============================================================================
`timescale 1ns/1ps
class base; int x; function new(int v); x=v; endfunction virtual function void disp(); $display("base:x=%0d",x); endfunction endclass
class derived extends base; int y; function new(int a,b); super.new(a); y=b; endfunction virtual function void disp(); $display("derived:x=%0d y=%0d",x,y); endfunction endclass
module tb_oop; initial begin base b; derived d; b=new(10); d=new(20,30); b.disp(); d.disp(); b=d; $cast(d,b); d.disp(); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_oop); end endmodule
