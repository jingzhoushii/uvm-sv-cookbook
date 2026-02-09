// ============================================================
// File: 01_randomization.sv
// Description: SystemVerilog 随机化示例
// ============================================================

`timescale 1ns/1ps

module randomization_demo;
    
    // 1. 基础随机类
    class Transaction;
        rand bit [31:0] addr;
        rand bit [31:0] data;
        rand bit        rw;  // 0=read, 1=write
        
        // 约束
        constraint addr_range {
            addr inside {[32'h0000_0000 : 32'h0FFF_FFFF]};
        }
        
        constraint data_range {
            data != 32'h0000_0000;
            data != 32'hFFFF_FFFF;
        }
        
        constraint rw_ratio {
            rw dist {0:/50, 1:/50};
        }
    endclass
    
    // 2. 约束模式
    class ConstrainedTx;
        rand bit [7:0] data;
        
        constraint c_normal { data inside {[10:100]}; }
        constraint c_small { data inside {[1:10]}; }
        constraint c_large { data inside {[200:255]}; }
        
        function void set_mode(string mode);
            case (mode)
                "normal": c_normal.constraint_mode(1);
                "small":  c_small.constraint_mode(1);
                "large":  c_large.constraint_mode(1);
            endcase
        endfunction
    endclass
    
    // 3. 随机权重
    class WeightedTx;
        rand bit [7:0] opcode;
        
        constraint op_weights {
            opcode dist {
                8'h00 :/ 10,  // 10% 概率
                8'h01 :/ 30,  // 30%
                8'h02 :/ 60   // 60%
            };
        }
    endclass
    
    Transaction t;
    ConstrainedTx ct;
    WeightedTx wt;
    
    initial begin
        $display("========================================");
        $display("  Randomization Demo");
        $display("========================================");
        $display("");
        
        t = new();
        $display("--- 基础随机化 ---");
        repeat (5) begin
            void'(t.randomize());
            $display("addr=0x%0h data=0x%0h rw=%b", t.addr, t.data, t.rw);
        end
        
        $display("");
        $display("--- 约束模式 ---");
        ct = new();
        ct.set_mode("small");
        repeat (3) begin
            void'(ct.randomize());
            $display("data=%0d", ct.data);
        end
        
        $display("");
        ct.set_mode("large");
        repeat (3) begin
            void'(ct.randomize());
            $display("data=%0d", ct.data);
        end
        
        $display("");
        $display("--- 权重分布 ---");
        wt = new();
        wt.opcode.constraint_mode(0);  // 禁用默认约束
        wt.op_weights.constraint_mode(1);
        repeat (10) begin
            void'(wt.randomize());
            $display("opcode=0x%0h", wt.opcode);
        end
        
        $display("");
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, randomization_demo);
    end
    
endmodule
