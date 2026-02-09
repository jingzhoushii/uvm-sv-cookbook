// ============================================================
// Interface: bus_if.sv
// Description: AXI-Lite 简化总线接口
// ============================================================

interface bus_if #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32
) (
    input logic clk,
    input logic rst_n
);
    
    // Write Address Channel
    wire [ADDR_W-1:0] awaddr;
    wire             awvalid;
    wire             awready;
    
    // Write Data Channel
    wire [DATA_W-1:0] wdata;
    wire [DATA_W/8-1:0] wstrb;
    wire             wvalid;
    wire             wready;
    
    // Write Response Channel
    wire [1:0]       bresp;
    wire             bvalid;
    wire             bready;
    
    // Read Address Channel
    wire [ADDR_W-1:0] araddr;
    wire             arvalid;
    wire             arready;
    
    // Read Data Channel
    wire [DATA_W-1:0] rdata;
    wire [1:0]       rresp;
    wire             rvalid;
    wire             rready;
    
    // Modports
    modport master (
        // Write
        output awaddr, awvalid,
        input  awready,
        output wdata, wstrb, wvalid,
        input  wready,
        input  bresp, bvalid,
        output bready,
        // Read
        output araddr, arvalid,
        input  arready,
        input  rdata, rresp, rvalid,
        output rready,
        // Clock/Reset
        input clk, rst_n
    );
    
    modport slave (
        // Write
        input  awaddr, awvalid,
        output awready,
        input  wdata, wstrb, wvalid,
        output wready,
        output bresp, bvalid,
        input  bready,
        // Read
        input  araddr, arvalid,
        output arready,
        output rdata, rresp, rvalid,
        input  rready,
        // Clock/Reset
        input clk, rst_n
    );
    
    // Clocking Block (用于 testbench)
    clocking cb @(posedge clk);
        default input #1step output #1;
        // Write
        output awaddr, awvalid, wdata, wstrb, wvalid, bready;
        input  awready, wready, bresp, bvalid;
        // Read
        output araddr, arvalid, rready;
        input  arready, rdata, rresp, rvalid;
    endclocking
    
endinterface
