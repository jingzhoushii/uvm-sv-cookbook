// ============================================================================
// Mini SoC - 贯穿式 DUT
// ============================================================================

`timescale 1ns/1ps

module mini_soc (
    input  bit         clk,
    input  bit         rst_n,
    
    // AHB Interface (Master)
    output bit [31:0]  haddr,
    output bit [31:0]  hwdata,
    output bit         hwrite,
    output bit [2:0]   hsize,
    output bit [2:0]   hburst,
    input  bit [31:0]   hrdata,
    input  bit         hready,
    input  bit         hresp,
    
    // GPIO
    input  bit [31:0]  gpio_in,
    output bit [31:0]  gpio_out,
    output bit [31:0]  gpio_oe,
    
    // Timer
    input  bit         timer_irq,
    output bit         timer_clk
);
    
    // 内部信号
    logic [31:0] gpio_reg;
    logic [31:0] timer_val;
    
    // GPIO 输出
    assign gpio_out = gpio_reg;
    assign gpio_oe = 32'hFFFFFFFF;
    
    // Timer 简单实现
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timer_val <= 0;
        end else begin
            timer_val <= timer_val + 1;
        end
    end
    assign timer_irq = (timer_val[31] == 1'b1);
    
    // AHB 从设备选择逻辑
    always @(posedge clk) begin
        if (hready && hwrite) begin
            case (haddr[7:0])
                8'h00: gpio_reg <= hwdata;  // GPIO
                8'h04: ; // Reserved
            endcase
        end
    end
    
    // 读数据
    assign hrdata = (haddr[7:0] == 8'h00) ? gpio_reg : timer_val;
    assign hready = 1'b1;
    assign hresp = 1'b0;
    
endmodule
