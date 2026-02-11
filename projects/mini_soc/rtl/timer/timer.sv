// ============================================================================
// Timer - 简单定时器
// ============================================================================

`timescale 1ns/1ps

module timer (
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
    
    // 中断
    output bit                      irq
);
    
    // 寄存器
    localparam REG_VAL  = 8'h00;
    localparam REG_LOAD = 8'h04;
    localparam REG_CTRL = 8'h08;
    localparam REG_STAT = 8'h0C;
    
    // 控制位
    localparam CTRL_EN    = 0;
    localparam CTRL_MODE  = 1;  // 0: 单次, 1: 自动重载
    localparam CTRL_IRQ   = 2;
    
    reg [31:0] timer_val;
    reg [31:0] timer_load;
    reg [31:0] ctrl_reg;
    reg [31:0] stat_reg;
    
    // AHB 响应
    assign hrdata   = (haddr[7:0] == REG_VAL)   ? timer_val :
                      (haddr[7:0] == REG_LOAD)  ? timer_load :
                      (haddr[7:0] == REG_CTRL)   ? ctrl_reg :
                      (haddr[7:0] == REG_STAT)   ? stat_reg : 32'h0;
    assign hready   = 1'b1;
    assign hresp    = 2'b00;
    assign irq      = stat_reg[0] && ctrl_reg[CTRL_IRQ];
    
    // 定时器逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timer_val <= 32'h0;
            timer_load <= 32'h0;
            ctrl_reg <= 32'h0;
            stat_reg <= 32'h0;
        end else begin
            // 寄存器写
            if (hsel && hwrite) begin
                case (haddr[7:0])
                    REG_VAL:  timer_val <= hwdata;
                    REG_LOAD:  timer_load <= hwdata;
                    REG_CTRL:  ctrl_reg <= hwdata;
                    REG_STAT:  stat_reg <= hwdata;  // 写1清零
                endcase
            end
            
            // 定时器计数
            if (ctrl_reg[CTRL_EN]) begin
                if (timer_val == 0) begin
                    if (ctrl_reg[CTRL_MODE]) begin  // 自动重载
                        timer_val <= timer_load;
                        stat_reg[0] <= 1'b1;  // 中断标志
                    end else begin
                        stat_reg[0] <= 1'b1;
                    end
                end else begin
                    timer_val <= timer_val - 1;
                end
            end
        end
    end
    
endmodule
