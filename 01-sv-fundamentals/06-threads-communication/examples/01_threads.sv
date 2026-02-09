// ============================================================
// File: 01_threads.sv
// Description: SystemVerilog 线程通信示例
// ============================================================

`timescale 1ns/1ps

module threads_demo;
    
    reg clk;
    reg [7:0] data;
    
    // 时钟
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 1. fork-join
    reg flag1, flag2, flag3;
    
    initial begin
        $display("========================================");
        $display("  Threads Communication Demo");
        $display("========================================");
        $display("");
        
        // fork-join: 三个线程并行执行
        $display("--- fork-join ---");
        fork
            begin
                #10;
                flag1 = 1;
                $display("Thread 1 done at %0t", $time);
            end
            begin
                #20;
                flag2 = 1;
                $display("Thread 2 done at %0t", $time);
            end
            begin
                #15;
                flag3 = 1;
                $display("Thread 3 done at %0t", $time);
            end
        join
        
        $display("All threads done at %0t", $time);
        
        // fork-join_any
        $display("");
        $display("--- fork-join_any ---");
        fork
            begin #10; $display("A done at %0t", $time); end
            begin #20; $display("B done at %0t", $time); end
            begin #15; $display("C done at %0t", $time); end
        join_any
        $display("First thread done at %0t", $time);
        
        // 2. semaphore (信号量)
        semaphore sem;
        sem = new(2);  // 2 个 key
        
        fork
            process_a();
            process_b();
            process_c();
        join
        
        // 3. mailbox (邮箱)
        mailbox #(int) mb;
        mb = new();
        
        fork
            producer(mb);
            consumer(mb);
        join
        
        #100;
        
        $display("");
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    // 信号量任务
    task process_a();
        sem.get(1);
        $display("Process A acquired key at %0t", $time);
        #10;
        sem.put(1);
        $display("Process A released key at %0t", $time);
    endtask
    
    task process_b();
        sem.get(1);
        $display("Process B acquired key at %0t", $time);
        #15;
        sem.put(1);
        $display("Process B released key at %0t", $time);
    endtask
    
    task process_c();
        sem.get(1);
        $display("Process C acquired key at %0t", $time);
        #20;
        sem.put(1);
        $display("Process C released key at %0t", $time);
    endtask
    
    // 邮箱任务
    task producer(mailbox #(int) m);
        for (int i = 0; i < 5; i++) begin
            m.put(i);
            $display("Producer put: %0d at %0t", i, $time);
            #5;
        end
    endtask
    
    task consumer(mailbox #(int) m);
        int val;
        for (int i = 0; i < 5; i++) begin
            m.get(val);
            $display("Consumer got: %0d at %0t", val, $time);
            #10;
        end
    endtask
    
    // 事件
    event done;
    
    initial begin
        $display("");
        $display("--- Events ---");
        fork
            begin
                #50;
                ->done;
            end
            begin
                @(done);
                $display("Event triggered at %0t", $time);
            end
        join
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, threads_demo);
    end
    
endmodule
