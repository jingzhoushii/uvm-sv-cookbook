// ============================================================================
// Testbench: tb_randomization
// 功能: 验证 SystemVerilog 随机化和约束的使用方法
// 知识点: rand, randc, constraint, randomize()
// ============================================================================
`timescale 1ns/1ps

module tb_randomization;
    // ------------------------------------------------------------------------
    // 示例：带约束的 Transaction 类
    // ------------------------------------------------------------------------
    class transaction;
        rand bit [7:0]  addr;     // 随机地址 (0-255)
        rand bit [7:0]  data;    // 随机数据 (0-255)
        rand bit         rw;     // 随机读写标志
        
        // 约束：地址范围
        constraint addr_range {
            addr inside {[16'h0000 : 16'h00FF]};  // 只使用低 256 地址
        }
        
        // 约束：数据范围
        constraint data_range {
            data dist {[0:50]:=30, [51:200]:=50, [201:255]:=20};  // 加权分布
        }
        
        // 约束：读写比例
        constraint rw_ratio {
            rw dist {0:/40, 1:/60};  // 读 40%，写 60%
        }
        
        // 打印函数
        function void print(string msg = "");
            $display("%s addr=0x%0h data=0x%0h rw=%0d", msg, addr, data, rw);
        endfunction
    endclass
    
    // ------------------------------------------------------------------------
    // 测试程序
    // ------------------------------------------------------------------------
    initial begin
        $display("========================================");
        $display("  SystemVerilog Randomization Demo");
        $display("========================================");
        
        transaction tr;
        tr = new();
        
        // 生成 10 个随机事务
        for (int i = 0; i < 10; i++) begin
            // 随机化并检查结果
            if (tr.randomize()) begin
                tr.print($sformatf("[%0d] ", i));
            end else begin
                $display("Randomization failed!");
            end
            
            #10;  // 间隔 10ns
        end
        
        // 演示条件约束
        $display("\n--- 条件约束演示 ---");
        tr.addr = 200;  // 设置特定地址
        if (tr.randomize() with { addr > 250; }) begin
            tr.print("[condition]");
        end
        
        $display("\nRandomization testbench Complete!");
        #100; $finish;
    end
    
    // ------------------------------------------------------------------------
    // 波形记录
    // ------------------------------------------------------------------------
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_randomization);
    end
    
endmodule
