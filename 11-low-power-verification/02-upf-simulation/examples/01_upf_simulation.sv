// ============================================================================
// @file    : 01_upf_simulation.sv
// @brief   : UPF 仿真演示
// @note    : 展示电源状态切换
// ============================================================================

`timescale 1ns/1ps

module upf_design(
    input wire clk,
    input wire rst_n,
    input wire pwr_on,
    output reg [7:0] data
);
    // 电源域
    // --------------------
    // 假设 power_domain_a 有 pwr_on 控制
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 8'h00;
        end else if (pwr_on) begin
            data <= data + 1;
        end
    end
endmodule

// UPF 脚本示例（保存为 design.upf）
/*
create_power_domain TOP
create_power_domain PD_A -elements {u_cpu}

create_supply_net VDD -domain TOP
create_supply_net VDD_A -domain PD_A
create_supply_port VDD -direction in
create_supply_port VDD_A -direction in

connect_supply_net VDD -ports {VDD}
connect_supply_net VDD_A -ports {VDD_A}

set_power_state VDD_A -state {ON OFF} -simulate_state
*/

module tb_upf_simulation;
    bit clk;
    bit rst_n;
    bit pwr_on;
    reg [7:0] data;
    
    upf_design dut (clk, rst_n, pwr_on, data);
    
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst_n = 0; #10 rst_n = 1; end
    
    initial begin
        $display("========================================");
        $display("  UPF Simulation Demo");
        $display("========================================");
        
        // Power ON
        #20 pwr_on = 1;
        $display("[%0t] Power ON", $time);
        repeat (5) @(posedge clk);
        
        // Power OFF
        #50 pwr_on = 0;
        $display("[%0t] Power OFF", $time);
        repeat (3) @(posedge clk);
        
        // Power ON again
        #50 pwr_on = 1;
        $display("[%0t] Power ON", $time);
        
        #200;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_upf_simulation); end
endmodule
