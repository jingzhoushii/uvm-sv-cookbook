`timescale 1ns/1ps

module tb_interfaces;
    bit clk, rst_n;
    bus_if ifc (clk, rst_n);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
        
        repeat (5) begin
            ifc.addr = $random & 32'h00FF;
            ifc.wdata = $random;
            ifc.valid = 1'b1;
            @(posedge clk);
            #1;
            $display("addr=0x%0h wdata=0x%0h", ifc.addr, ifc.wdata);
        end
        
        $display("Interface Demo Complete!");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_interfaces);
    end
endmodule
