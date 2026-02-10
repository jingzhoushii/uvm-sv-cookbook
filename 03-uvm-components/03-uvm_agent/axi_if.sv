// ============================================================================
// @file    : axi_if.sv
// @brief   : AXI4-Lite 接口
// @note    : 用于连接 DUT 和 Agent
// ============================================================================

`timescale 1ns/1ps

interface axi_if (
    input bit clk,
    input bit rst_n
);
    // ------------------------------------------------------------------------
    // Write Address Channel
    // ------------------------------------------------------------------------
    wire [31:0]      awaddr;
    wire [2:0]       awsize;
    wire [1:0]       awburst;
    wire [3:0]       awcache;
    wire [5:0]       awprot;
    wire [3:0]       awqos;
    wire [0:0]       awid;
    wire             awvalid;
    wire             awready;
    
    // ------------------------------------------------------------------------
    // Write Data Channel
    // ------------------------------------------------------------------------
    wire [31:0]      wdata;
    wire [3:0]       wstrb;
    wire             wlast;
    wire             wvalid;
    wire             wready;
    
    // ------------------------------------------------------------------------
    // Write Response Channel
    // ------------------------------------------------------------------------
    wire [0:0]       bid;
    wire [1:0]       bresp;
    wire             bvalid;
    wire             bready;
    
    // ------------------------------------------------------------------------
    // Read Address Channel
    // ------------------------------------------------------------------------
    wire [31:0]      araddr;
    wire [7:0]       arlen;
    wire [2:0]       arsize;
    wire [1:0]       arburst;
    wire [3:0]       arcache;
    wire [5:0]       arprot;
    wire [3:0]       arqos;
    wire [0:0]       arid;
    wire             arvalid;
    wire             arready;
    
    // ------------------------------------------------------------------------
    // Read Data Channel
    // ------------------------------------------------------------------------
    wire [0:0]       rid;
    wire [31:0]      rdata;
    wire [1:0]       rresp;
    wire             rlast;
    wire             rvalid;
    wire             rready;
    
    // ------------------------------------------------------------------------
    // 时序检查
    // ------------------------------------------------------------------------
    always @(posedge clk) begin
        if (awvalid && !awready) begin
            `uvm_warning("AXI", "AWVALID asserted without AWREADY")
        end
    end
    
endinterface : axi_if
