// ============================================================
// Module: alu.sv
// Description: Simple ALU for data type demo
// ============================================================

module alu (
    input  wire        clk,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    input  wire [2:0]  op,
    output reg  [7:0]  result,
    output reg         zero,
    output reg         overflow
);

    always @(posedge clk) begin
        case (op)
            3'b000: {overflow, result} = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            default: result = 8'b0;
        endcase
        zero = (result == 8'b0);
    end

endmodule
