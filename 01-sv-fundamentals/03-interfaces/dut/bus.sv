// Simple bus interface
interface bus_if (input clk, input rst_n);
    logic [31:0] addr;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic        valid;
    logic        ready;
    
    modport master (
        output addr, wdata, valid,
        input  rdata, ready
    );
    
    modport slave (
        input  addr, wdata, valid,
        output rdata, ready
    );
endinterface
