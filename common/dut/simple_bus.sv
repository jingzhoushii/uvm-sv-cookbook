// ============================================================================
// @file    : simple_bus.sv
// @brief   : 简单总线 DUT
// @note    : 用于验证示例的基础总线
// ============================================================================

`timescale 1ns/1ps

module simple_bus #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input  wire                  clk,
    input  wire                  rst_n,
    
    // 写通道
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire                  wr_en,
    output reg                   wr_ready,
    
    // 读通道
    input  wire [ADDR_WIDTH-1:0] raddr,
    input  wire                  rd_en,
    output reg  [DATA_WIDTH-1:0] rdata,
    output reg                   rd_ready,
    
    // 状态
    output reg  [7:0]           state
);

    // 状态定义
    typedef enum logic [7:0] {
        IDLE     = 8'h00,
        WRITE    = 8'h01,
        READ     = 8'h02,
        DONE     = 8'h03
    } bus_state_e;
    
    bus_state_e current_state, next_state;
    
    // 寄存器文件
    reg [DATA_WIDTH-1:0] mem [0:255];
    
    // 状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            state <= 8'h00;
        end else begin
            current_state <= next_state;
            state <= current_state;
        end
    end
    
    // 状态转换逻辑
    always_comb begin
        next_state = current_state;
        wr_ready = 1'b0;
        rd_ready = 1'b0;
        rdata = 32'h0;
        
        case (current_state)
            IDLE: begin
                if (wr_en) begin
                    next_state = WRITE;
                end else if (rd_en) begin
                    next_state = READ;
                end
            end
            
            WRITE: begin
                wr_ready = 1'b1;
                next_state = DONE;
            end
            
            READ: begin
                rd_ready = 1'b1;
                rdata = mem[raddr[7:0]];
                next_state = DONE;
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // 写操作
    always @(posedge clk) begin
        if (wr_ready && wr_en) begin
            mem[waddr[7:0]] <= wdata;
        end
    end
    
endmodule : simple_bus
