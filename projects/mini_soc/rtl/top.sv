// ============================================================================
// Mini SoC Top - 顶层模块
// ============================================================================

`timescale 1ns/1ps

module mini_soc (
    input  bit                      clk,
    input  bit                      rst_n,
    
    // UART 引脚
    input  bit                      uart_rx,
    output bit                      uart_tx,
    
    // 外部中断
    input  bit [3:0]               ext_irq,
    output bit [3:0]               timer_irq
);
    
    // 时钟和复位
    wire clk_sys;
    assign clk_sys = clk;
    
    // AHB 信号
    wire [31:0] haddr;
    wire [31:0] hwdata;
    wire        hwrite;
    wire [2:0]  hsize;
    wire [2:0]  hburst;
    wire [31:0] hrdata;
    wire        hready;
    wire [1:0]  hresp;
    
    // 总线矩阵信号
    wire [3:0]  s_hsel;
    wire [31:0] s_haddr;
    wire [31:0] s_hwdata;
    wire        s_hwrite;
    wire [2:0]  s_hsize;
    wire [2:0]  s_hburst;
    wire [3:0][31:0] s_hrdata;
    wire [3:0]       s_hready;
    wire [3:0][1:0]  s_hresp;
    
    // 中断
    wire uart_irq;
    wire dma_irq;
    wire [3:0] timer_irq;
    
    // =========================================================================
    // 实例化 CPU Stub
    // =========================================================================
    cpu_stub u_cpu (
        .clk      (clk_sys),
        .rst_n    (rst_n),
        .haddr    (haddr),
        .hwdata   (hwdata),
        .hwrite   (hwrite),
        .hsize    (hsize),
        .hburst   (hburst),
        .hrdata   (hrdata),
        .hready   (hready),
        .hresp    (hresp),
        .fetch_en (1'b1),
        .busy     ()
    );
    
    // =========================================================================
    // 实例化系统总线
    // =========================================================================
    system_bus u_bus (
        .clk       (clk_sys),
        .rst_n     (rst_n),
        .m_haddr   (haddr),
        .m_hwdata  (hwdata),
        .m_hwrite  (hwrite),
        .m_hsize   (hsize),
        .m_hburst  (hburst),
        .m_hsel    (1'b1),
        .m_hrdata  (hrdata),
        .m_hready  (hready),
        .m_hresp   (hresp),
        .s_hsel    (s_hsel),
        .s_haddr   (s_haddr),
        .s_hwdata  (s_hwdata),
        .s_hwrite  (s_hwrite),
        .s_hsize   (s_hsize),
        .s_hburst  (s_hburst),
        .s_hrdata  (s_hrdata),
        .s_hready  (s_hready),
        .s_hresp   (s_hresp)
    );
    
    // =========================================================================
    // 实例化 DMA 控制器 (Slave 1)
    // =========================================================================
    assign s_hrdata[1] = 32'h0;  // DMA 无寄存器读回
    assign s_hready[1] = 1'b1;
    assign s_hresp[1]  = 2'b00;
    
    dma_controller u_dma (
        .clk       (clk_sys),
        .rst_n     (rst_n),
        .haddr     (s_hsel[1] ? s_haddr : 32'b0),
        .hwdata    (s_hwdata),
        .hwrite    (s_hwrite),
        .hsize     (s_hsize),
        .hsel      (s_hsel[1]),
        .hrdata    (),
        .hready    (),
        .hresp     (),
        .m_haddr   (haddr),
        .m_hwdata  (hwdata),
        .m_hwrite  (hwrite),
        .m_hsize   (hsize),
        .m_hburst  (hburst),
        .m_hrdata  (hrdata),
        .m_hready  (hready),
        .m_hresp   (hresp),
        .irq       (dma_irq)
    );
    
    // =========================================================================
    // 实例化 UART (Slave 2)
    // =========================================================================
    assign s_hrdata[2] = 32'h0;
    assign s_hready[2] = 1'b1;
    assign s_hresp[2]  = 2'b00;
    
    uart #(.CLK_FREQ(100_000_000), .BAUD_RATE(115200)) u_uart (
        .clk     (clk_sys),
        .rst_n   (rst_n),
        .haddr   (s_hsel[2] ? s_haddr : 32'b0),
        .hwdata  (s_hwdata),
        .hwrite  (s_hwrite),
        .hsize   (s_hsize),
        .hsel    (s_hsel[2]),
        .hrdata  (),
        .hready  (),
        .hresp   (),
        .rx      (uart_rx),
        .tx      (uart_tx),
        .irq     (uart_irq)
    );
    
    // =========================================================================
    // 实例化 Timer (Slave 3)
    // =========================================================================
    assign s_hrdata[3] = 32'h0;
    assign s_hready[3] = 1'b1;
    assign s_hresp[3]  = 2'b00;
    
    timer u_timer (
        .clk     (clk_sys),
        .rst_n   (rst_n),
        .haddr   (s_hsel[3] ? s_haddr : 32'b0),
        .hwdata  (s_hwdata),
        .hwrite  (s_hwrite),
        .hsize   (s_hsize),
        .hsel    (s_hsel[3]),
        .hrdata  (),
        .hready  (),
        .hresp   (),
        .irq     (timer_irq[0])
    );
    
endmodule
