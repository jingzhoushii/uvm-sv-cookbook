// Bus interface DUT
`timescale 1ns/1ps
module bus_dut(
    input clk, rst_n,
    bus_if.master ifc
);
    always @(posedge clk)
        if (ifc.valid && ifc.ready)
            ifc.data <= ifc.addr + 1;
endmodule
