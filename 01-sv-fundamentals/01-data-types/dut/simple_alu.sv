// ============================================================
// Module: simple_alu.sv
// Description: Simple ALU for demonstrating data types
// ============================================================

module simple_alu #(
    parameter DATA_W = 8,
    parameter OP_W   = 3
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire [DATA_W-1:0]       a,
    input  wire [DATA_W-1:0]       b,
    input  wire [OP_W-1:0]         op,
    output wire [DATA_W-1:0]       result,
    output wire                    zero,
    output wire                    overflow
);

    // 本地参数定义
    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;
    localparam OP_NOT = 3'b101;
    localparam OP_LSL = 3'b110;
    localparam OP_LSR = 3'b111;

    // 寄存器定义
    reg [DATA_W:0] result_ext;  // 扩展 1 位用于溢出检测

    // 组合逻辑: ALU 操作
    always @(*) begin
        case (op)
            OP_ADD: result_ext = {1'b0, a} + {1'b0, b};
            OP_SUB: result_ext = {1'b0, a} - {1'b0, b};
            OP_AND: result_ext = {1'b0, a & b};
            OP_OR:  result_ext = {1'b0, a | b};
            OP_XOR: result_ext = {1'b0, a ^ b};
            OP_NOT: result_ext = {1'b0, ~a};
            OP_LSL: result_ext = {1'b0, a << b[2:0]};
            OP_LSR: result_ext = {1'b0, a >> b[2:0]};
            default: result_ext = '0;
        endcase
    end

    // 输出赋值
    assign result  = result_ext[DATA_W-1:0];
    assign overflow = result_ext[DATA_W];  // 进位/借位标志
    assign zero = ~|result_ext[DATA_W-1:0];

endmodule
