// ============================================================================
// UART - 简化的 UART 控制器
// ============================================================================

`timescale 1ns/1ps

module uart #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 115_200
) (
    input  bit                      clk,
    input  bit                      rst_n,
    
    // AHB Slave 接口
    input  bit [31:0]               haddr,
    input  bit [31:0]               hwdata,
    input  bit                      hwrite,
    input  bit [2:0]                hsize,
    input  bit                      hsel,
    output bit [31:0]               hrdata,
    output bit                      hready,
    output bit [1:0]               hresp,
    
    // UART 引脚
    input  bit                      rx,
    output bit                      tx,
    output bit                      irq
);
    
    // 寄存器偏移
    localparam REG_DATA  = 8'h00;
    localparam REG_STAT  = 8'h04;
    localparam REG_CTRL  = 8'h08;
    localparam REG_DIV   = 8'h0C;
    
    // 状态寄存器位
    localparam STAT_RX_RDY = 0;
    localparam STAT_TX_RDY = 1;
    localparam STAT_TX_FULL = 2;
    localparam STAT_RX_FULL = 3;
    
    reg [31:0] ctrl_reg;
    reg [31:0] div_reg;
    reg [7:0]  rx_buf;
    reg [7:0]  tx_buf;
    
    reg rx_rdy;
    reg tx_rdy;
    reg tx_full;
    reg rx_full;
    
    // 波特率生成
    localparam DIV = CLK_FREQ / BAUD_RATE / 16;
    
    reg [15:0] baud_cnt;
    reg [3:0]  bit_cnt;
    reg [7:0]  tx_shift;
    reg [7:0]  rx_shift;
    reg tx_active;
    
    // AHB 响应
    assign hrdata   = (haddr[7:0] == REG_DATA)  ? {24'b0, rx_buf} :
                      (haddr[7:0] == REG_STAT)  ? {28'b0, rx_full, tx_full, tx_rdy, rx_rdy} :
                      (haddr[7:0] == REG_CTRL)  ? ctrl_reg :
                      (haddr[7:0] == REG_DIV)   ? div_reg : 32'h0;
    assign hready   = 1'b1;
    assign hresp    = 2'b00;
    assign tx       = tx_active ? tx_shift[0] : 1'b1;
    assign irq      = rx_rdy;  // RX 中断
    
    // 初始化
    initial begin
        div_reg = DIV[15:0];
        ctrl_reg = 32'h0;
    end
    
    // 寄存器写
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_reg <= 32'h0;
            tx_buf <= 8'h0;
            rx_rdy <= 1'b0;
            rx_full <= 1'b0;
        end else begin
            if (hsel && hwrite) begin
                case (haddr[7:0])
                    REG_DATA: begin
                        tx_buf <= hwdata[7:0];
                        tx_rdy <= 1'b0;
                    end
                    REG_CTRL: ctrl_reg <= hwdata;
                    REG_DIV:  div_reg <= hwdata;
                endcase
            end
            
            // RX 完成
            if (rx_rdy) begin
                rx_rdy <= 1'b0;
                rx_full <= 1'b0;
            end
        end
    end
    
    // TX 逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_active <= 1'b0;
            tx_shift <= 8'hFF;
            baud_cnt <= 0;
            bit_cnt <= 0;
        end else begin
            if (ctrl_reg[0] && !tx_active && !tx_rdy) begin  // TX 使能
                tx_active <= 1'b1;
                tx_shift <= tx_buf;
                baud_cnt <= 0;
                bit_cnt <= 0;
            end
            
            if (tx_active) begin
                baud_cnt <= baud_cnt + 1;
                if (baud_cnt == div_reg[15:0]) begin
                    baud_cnt <= 0;
                    if (bit_cnt < 10) begin
                        bit_cnt <= bit_cnt + 1;
                        tx_shift <= {1'b1, tx_shift[7:1]};  // LSB first
                    end else begin
                        tx_active <= 1'b0;
                        tx_rdy <= 1'b1;
                    end
                end
            end
        end
    end
    
    // RX 逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_shift <= 8'h0;
            baud_cnt <= 0;
            bit_cnt <= 0;
            rx_full <= 1'b0;
        end else begin
            if (ctrl_reg[1]) begin  // RX 使能
                if (!rx && bit_cnt == 0) begin  // 起始位
                    baud_cnt <= div_reg[15:0] / 2;
                    bit_cnt <= 1;
                end else if (bit_cnt > 0) begin
                    baud_cnt <= baud_cnt + 1;
                    if (baud_cnt == div_reg[15:0]) begin
                        baud_cnt <= 0;
                        if (bit_cnt < 10) begin
                            bit_cnt <= bit_cnt + 1;
                            if (bit_cnt >= 1 && bit_cnt <= 8)
                                rx_shift <= {rx, rx_shift[7:1]};
                        end else begin  // 停止位
                            bit_cnt <= 0;
                            rx_buf <= rx_shift;
                            rx_rdy <= 1'b1;
                            rx_full <= 1'b1;
                        end
                    end
                end
            end
        end
    end
    
endmodule
