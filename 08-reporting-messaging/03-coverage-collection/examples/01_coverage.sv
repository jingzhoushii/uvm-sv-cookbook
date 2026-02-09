// ============================================================
// File: 01_coverage.sv
// Description: 覆盖率示例
// ============================================================

`timescale 1ns/1ps

module coverage_demo;
    
    // 1. 基础覆盖率组
    bit [7:0] data;
    bit [2:0] opcode;
    bit       valid;
    
    covergroup cg_basic;
        coverpoint data {
            bins zero   = {8'h00};
            bins max    = {8'hFF};
            bins range1 = {[1:100]};
            bins range2 = {[101:200]};
        }
        coverpoint opcode {
            bins ops[] = {[0:7]};
        }
    endgroup
    
    // 2. 交叉覆盖率
    covergroup cg_cross;
        cp_data: coverpoint data {
            bins low  = {[0:127]};
            bins high = {[128:255]};
        }
        cp_op: coverpoint opcode {
            bins read = {0, 2, 4, 6};
            bins write = {1, 3, 5, 7};
        }
        cross_data_op: cross cp_data, cp_op {
            ignore_bins bad = binsof(cp_data.high) && binsof(cp_op.read);
        }
    endgroup
    
    cg_basic  cg1;
    cg_cross cg2;
    
    int i;
    
    initial begin
        cg1 = new();
        cg2 = new();
        
        $display("========================================");
        $display("  Coverage Demo");
        $display("========================================");
        $display("");
        
        repeat (50) begin
            data = $random;
            opcode = $random % 8;
            valid = 1'b1;
            
            cg1.sample();
            cg2.sample();
            
            if (i % 10 == 0) begin
                $display("data=0x%0h opcode=%0d coverage=%.1f%%", 
                        data, opcode, cg1.get_coverage());
            end
            i++;
            #10;
        end
        
        $display("");
        $display("--- Final Coverage ---");
        $display("Basic coverage: %.1f%%", cg1.get_coverage());
        $display("Cross coverage: %.1f%%", cg2.get_coverage());
        
        $display("");
        $display("========================================");
        $display("  Coverage Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, coverage_demo);
    end
    
endmodule
