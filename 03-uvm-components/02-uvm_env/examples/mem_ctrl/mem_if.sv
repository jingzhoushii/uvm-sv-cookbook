// ============================================================================
// @file    : mem_if.sv
// @brief   : 内存接口
// ============================================================================
`timescale 1ns/1ps

interface mem_if (input bit clk);
    logic [31:0] wr_addr;
    logic [31:0] wr_data;
    logic        wr_en;
    logic        wr_ready;
    
    logic [31:0] rd_addr;
    logic        rd_en;
    logic [31:0] rd_data;
    logic        rd_valid;
    
    // 时序检查
    always @(posedge clk) begin
        if (wr_en && !wr_ready) begin
            `uvm_warning("MEM", "Write without ready")
        end
    end
endinterface : mem_if

// 7. 内存 DUT
cat > /Users/jingzhoushi/.openclaw/workspace/uvm-sv-cookbook/03-uvm-components/02-uvm_env/examples/mem_ctrl/mem_dut.sv << 'EOF'
// ============================================================================
// @file    : mem_dut.sv
// @brief   : 简单内存 DUT
// ============================================================================
`timescale 1ns/1ps

module mem_dut (
    input bit clk,
    input bit rst_n,
    
    // 写端口
    input [31:0] wr_addr,
    input [31:0] wr_data,
    input        wr_en,
    output reg   wr_ready,
    
    // 读端口
    input [31:0] rd_addr,
    input        rd_en,
    output reg [31:0] rd_data,
    output reg   rd_valid
);
    parameter SIZE = 1024;
    
    reg [31:0] mem [0:SIZE-1];
    
    always @(posedge clk) begin
        wr_ready <= 1'b1;
        rd_valid <= 1'b0;
        
        if (wr_en && wr_ready) begin
            mem[wr_addr[9:0]] <= wr_data;
        end
        
        if (rd_en) begin
            rd_data <= mem[rd_addr[9:0]];
            rd_valid <= 1'b1;
        end
    end
endmodule : mem_dut
