// ============================================================================
// CPU Stub - 简化的处理器模型
// ============================================================================

`timescale 1ns/1ps

module cpu_stub #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input  bit                      clk,
    input  bit                      rst_n,
    
    // AHB Master 接口
    output bit [ADDR_WIDTH-1:0]    haddr,
    output bit [DATA_WIDTH-1:0]     hwdata,
    output bit                      hwrite,
    output bit [2:0]                hsize,
    output bit [2:0]                hburst,
    input  bit [DATA_WIDTH-1:0]     hrdata,
    input  bit                      hready,
    input  bit [1:0]               hresp,
    
    // 控制信号
    input  bit                      fetch_en,
    output bit                      busy
);
    
    // 内部寄存器
    reg [ADDR_WIDTH-1:0] pc;
    reg [ADDR_WIDTH-1:0] ir;
    reg [DATA_WIDTH-1:0] acc;
    reg [3:0] state;
    
    // 状态机
    localparam IDLE  = 4'b0000;
    localparam FETCH = 4'b0001;
    localparam DEC   = 4'b0010;
    localparam EXEC  = 4'b0011;
    
    // 输出
    assign haddr  = pc;
    assign hwdata = acc;
    assign hwrite = 1'b0;  // 简化为只读
    assign hsize  = 3'b010;  // Word
    assign hburst = 3'b000;  // Single
    assign busy   = (state != IDLE);
    
    // 指令存储器 (2KB)
    reg [31:0] instr_mem[0:511];
    
    // 初始化
    initial begin
        instr_mem[0]  = 32'h0000_0000;  // NOP
        instr_mem[1]  = 32'h1000_0010;  // LOAD 0x10
        instr_mem[2]  = 32'h2000_0020;  // LOAD 0x20
        instr_mem[3]  = 32'h3000_0030;  // ADD
        instr_mem[4]  = 32'h4000_0001;  // STORE
        instr_mem[5]  = 32'hF000_0000;  // HALT
    end
    
    // 状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 32'h0000_0000;
            state <= IDLE;
            acc <= 32'h0;
        end else begin
            case (state)
                IDLE: begin
                    if (fetch_en) begin
                        state <= FETCH;
                    end
                end
                FETCH: begin
                    if (hready) begin
                        ir <= hrdata;
                        pc <= pc + 4;
                        state <= DEC;
                    end
                end
                DEC: begin
                    case (ir[31:28])
                        4'b0000: state <= FETCH;  // NOP
                        4'b0001: state <= EXEC;  // LOAD
                        4'b0010: state <= EXEC;  // LOAD
                        4'b0011: state <= EXEC;  // ADD
                        4'b0100: state <= EXEC;  // STORE
                        4'b1111: state <= IDLE;  // HALT
                        default: state <= FETCH;
                    endcase
                end
                EXEC: begin
                    if (ir[31:28] == 4'b0001) begin  // LOAD
                        pc <= {20'b0, ir[11:0]};
                    end else if (ir[31:28] == 4'b0100) begin  // STORE
                        pc <= {20'b0, ir[11:0]};
                    end else begin
                        state <= FETCH;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
    
endmodule
