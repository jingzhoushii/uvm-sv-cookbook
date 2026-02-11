// ============================================================================
// System Bus Fabric - SoC 系统总线
// ============================================================================
// 简化版 AHB-Lite 总线矩阵
// ============================================================================

`timescale 1ns/1ps

module system_bus #(
    parameter SLAVE_COUNT = 4,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input  bit                      clk,
    input  bit                      rst_n,
    
    // Master 接口
    input  bit [ADDR_WIDTH-1:0]     m_haddr,
    input  bit [DATA_WIDTH-1:0]     m_hwdata,
    input  bit                      m_hwrite,
    input  bit [2:0]                m_hsize,
    input  bit [2:0]                m_hburst,
    input  bit                      m_hsel,
    output bit [DATA_WIDTH-1:0]     m_hrdata,
    output bit                      m_hready,
    output bit [1:0]                m_hresp,
    
    // Slave 接口 (4 slaves)
    output bit [SLAVE_COUNT-1:0]    s_hsel,
    output bit [ADDR_WIDTH-1:0]     s_haddr,
    output bit [DATA_WIDTH-1:0]     s_hwdata,
    output bit                      s_hwrite,
    output bit [2:0]                s_hsize,
    output bit [2:0]                s_hburst,
    input  bit [SLAVE_COUNT-1:0][DATA_WIDTH-1:0] s_hrdata,
    input  bit [SLAVE_COUNT-1:0]    s_hready,
    input  bit [SLAVE_COUNT-1:0][1:0]    s_hresp
);
    
    // 地址映射
    localparam [ADDR_WIDTH-1:0] SLAVE0_BASE = 32'h0000_0000;  // CPU Stub
    localparam [ADDR_WIDTH-1:0] SLAVE0_SIZE = 32'h0001_0000;
    localparam [ADDR_WIDTH-1:0] SLAVE1_BASE = 32'h1000_0000;  // DMA
    localparam [ADDR_WIDTH-1:0] SLAVE1_SIZE = 32'h0001_0000;
    localparam [ADDR_WIDTH-1:0] SLAVE2_BASE = 32'h2000_0000;  // UART
    localparam [ADDR_WIDTH-1:0] SLAVE2_SIZE = 32'h0001_0000;
    localparam [ADDR_WIDTH-1:0] SLAVE3_BASE = 32'h3000_0000;  // Timer
    localparam [ADDR_WIDTH-1:0] SLAVE3_SIZE = 32'h0001_0000;
    
    // 地址解码
    always_comb begin
        s_hsel = 0;
        casex ({m_haddr[19:16]})
            4'b0000: s_hsel[0] = 1'b1;  // 0x0000_xxxx
            4'b0001: s_hsel[0] = 1'b1;
            4'b0010: s_hsel[0] = 1'b1;
            4'b0011: s_hsel[0] = 1'b1;
            4'b0100: s_hsel[0] = 1'b1;
            4'b0101: s_hsel[0] = 1'b1;
            4'b0110: s_hsel[0] = 1'b1;
            4'b0111: s_hsel[0] = 1'b1;
            4'b1000: s_hsel[0] = 1'b1;
            4'b1001: s_hsel[1] = 1'b1;  // 0x1000_xxxx - DMA
            4'b1010: s_hsel[2] = 1'b1;  // 0x2000_xxxx - UART
            4'b1011: s_hsel[3] = 1'b1;  // 0x3000_xxxx - Timer
            default: s_hsel[0] = 1'b1;
        endcase
    end
    
    // 信号转发
    assign s_haddr  = m_haddr;
    assign s_hwdata = m_hwdata;
    assign s_hwrite = m_hwrite;
    assign s_hsize  = m_hsize;
    assign s_hburst = m_hburst;
    
    // 读数据选择
    always_comb begin
        case (s_hsel)
            4'b0001: m_hrdata = s_hrdata[0];
            4'b0010: m_hrdata = s_hrdata[1];
            4'b0100: m_hrdata = s_hrdata[2];
            4'b1000: m_hrdata = s_hrdata[3];
            default: m_hrdata = 32'h0;
        endcase
    end
    
    // Ready 和 Response
    assign m_hready = |s_hsel & (&s_hready);
    assign m_hresp  = 2'b00;
    
endmodule
