// ============================================================================
// DMA Controller - 直接内存访问控制器
// ============================================================================

`timescale 1ns/1ps

module dma_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter CHANNEL   = 2
) (
    input  bit                      clk,
    input  bit                      rst_n,
    
    // AHB Slave 接口 (寄存器)
    input  bit [ADDR_WIDTH-1:0]     haddr,
    input  bit [DATA_WIDTH-1:0]     hwdata,
    input  bit                      hwrite,
    input  bit [2:0]                hsize,
    input  bit                      hsel,
    output bit [DATA_WIDTH-1:0]     hrdata,
    output bit                      hready,
    output bit [1:0]                hresp,
    
    // AHB Master 接口 (内存访问)
    output bit [ADDR_WIDTH-1:0]    m_haddr,
    output bit [DATA_WIDTH-1:0]     m_hwdata,
    output bit                      m_hwrite,
    output bit [2:0]                m_hsize,
    output bit [2:0]                m_hburst,
    input  bit [DATA_WIDTH-1:0]     m_hrdata,
    input  bit                      m_hready,
    input  bit [1:0]                m_hresp,
    
    // 中断
    output bit                      irq
);
    
    // 寄存器定义
    localparam REG_CTRL   = 8'h00;  // 控制寄存器
    localparam REG_STATUS = 8'h04;  // 状态寄存器
    localparam REG_SRC    = 8'h08;  // 源地址
    localparam REG_DST    = 8'h0C;  // 目标地址
    localparam REG_LEN    = 8'h10;  // 传输长度
    
    // 控制寄存器位
    localparam CTRL_EN    = 0;
    localparam CTRL_START = 1;
    localparam CTRL_IRQ   = 2;
    
    reg [31:0] ctrl_reg;
    reg [31:0] status_reg;
    reg [31:0] src_addr;
    reg [31:0] dst_addr;
    reg [31:0] trans_len;
    
    // 状态机
    reg [2:0] state;
    localparam IDLE = 3'b000;
    localparam READ = 3'b001;
    localparam WRITE = 3'b010;
    localparam DONE = 3'b011;
    
    reg [31:0] data_buf;
    reg [31:0] remaining;
    
    // AHB Slave 响应
    assign hrdata   = (haddr[7:0] == REG_CTRL)   ? ctrl_reg :
                      (haddr[7:0] == REG_STATUS)  ? status_reg :
                      (haddr[7:0] == REG_SRC)     ? src_addr :
                      (haddr[7:0] == REG_DST)     ? dst_addr :
                      (haddr[7:0] == REG_LEN)     ? trans_len : 32'h0;
    assign hready   = 1'b1;
    assign hresp    = 2'b00;
    
    // AHB Master 输出
    assign m_haddr  = (state == READ)  ? src_addr :
                       (state == WRITE) ? dst_addr : 32'h0;
    assign m_hwdata = data_buf;
    assign m_hwrite = (state == WRITE);
    assign m_hsize  = 3'b010;  // Word
    assign m_hburst = 3'b000;  // Single
    
    // 状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_reg <= 32'h0;
            src_addr <= 32'h0;
            dst_addr <= 32'h0;
            trans_len <= 32'h0;
            state <= IDLE;
            remaining <= 32'h0;
            irq <= 1'b0;
        end else begin
            // 寄存器写
            if (hsel && hwrite) begin
                case (haddr[7:0])
                    REG_CTRL:  ctrl_reg <= hwdata;
                    REG_SRC:   src_addr <= hwdata;
                    REG_DST:   dst_addr <= hwdata;
                    REG_LEN:   trans_len <= hwdata;
                endcase
            end
            
            // DMA 传输
            if (ctrl_reg[CTRL_EN] && ctrl_reg[CTRL_START]) begin
                case (state)
                    IDLE: begin
                        remaining <= trans_len;
                        state <= READ;
                    end
                    READ: begin
                        if (m_hready) begin
                            data_buf <= m_hrdata;
                            state <= WRITE;
                        end
                    end
                    WRITE: begin
                        if (m_hready) begin
                            src_addr <= src_addr + 4;
                            dst_addr <= dst_addr + 4;
                            remaining <= remaining - 4;
                            if (remaining <= 4) begin
                                state <= DONE;
                                ctrl_reg[CTRL_EN] <= 1'b0;
                                if (ctrl_reg[CTRL_IRQ])
                                    irq <= 1'b1;
                            end else begin
                                state <= READ;
                            end
                        end
                    end
                    DONE: begin
                        irq <= 1'b0;
                        state <= IDLE;
                        ctrl_reg[CTRL_START] <= 1'b0;
                    end
                endcase
            end else begin
                state <= IDLE;
            end
        end
    end
    
endmodule
