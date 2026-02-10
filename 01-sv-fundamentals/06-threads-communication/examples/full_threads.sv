// ============================================================================
// Full SystemVerilog Threads Example
// ============================================================================
`timescale 1ns/1ps
module tb_thr; int cnt; semaphore sm; mailbox #(int) mb;
    initial begin sm=new(2); mb=new(); cnt=0;
        fork begin repeat(3) begin sm.get(1); #10; cnt++; sm.put(1); end end
        fork begin repeat(3) begin int v; mb.get(v); $display("got=%0d",v); #5; end end join
        repeat(3) begin mb.put(cnt); end
        #100; $display("cnt=%0d",cnt); $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_thr); end
endmodule
