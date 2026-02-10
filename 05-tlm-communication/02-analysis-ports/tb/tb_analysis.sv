// ============================================================================
// Testbench: tb_analysis
// 功能: 验证 UVM Analysis Port 的使用方法
// 知识点: uvm_analysis_port, uvm_analysis_imp, write()
// ============================================================================
`timescale 1ns/1ps

module tb_analysis;
    // ------------------------------------------------------------------------
    // Transaction 类
    // ------------------------------------------------------------------------
    class transaction extends uvm_sequence_item;
        rand bit [31:0] addr;
        rand bit [31:0] data;
        bit             rw;
        
        `uvm_object_utils_begin(transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
        `uvm_object_utils_end
    endclass
    
    // ------------------------------------------------------------------------
    // 组件：监控器 (Monitor) - 产生事务并广播
    // ------------------------------------------------------------------------
    class monitor extends uvm_component;
        `uvm_component_utils(monitor)
        
        uvm_analysis_port#(transaction) ap;  // Analysis Port
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
            ap = new("ap", this);
        endfunction
        
        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            
            repeat (5) begin
                transaction tr;
                tr = new();
                tr.randomize();
                `uvm_info("MON", $sformatf("Sent: addr=0x%0h data=0x%0h", tr.addr, tr.data), UVM_LOW)
                ap.write(tr);  // 写入分析端口
                #10;
            end
            
            phase.drop_objection(this);
        endtask
    endclass
    
    // ------------------------------------------------------------------------
    // 组件：订阅者 (Subscriber) - 接收和分析事务
    // ------------------------------------------------------------------------
    class subscriber extends uvm_component;
        `uvm_component_utils(subscriber)
        
        uvm_analysis_imp#(transaction, subscriber) imp;  // Analysis Imp
        
        int transaction_count = 0;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
            imp = new("imp", this);
        endfunction
        
        // 实现 write() 方法接收事务
        virtual function void write(transaction tr);
            transaction_count++;
            `uvm_info("SUB", $sformatf("Received #%0d: addr=0x%0h data=0x%0h",
                                       transaction_count, tr.addr, tr.data), UVM_LOW)
        endfunction
        
        virtual function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("SUB", $sformatf("Total transactions: %0d", transaction_count), UVM_LOW)
        endfunction
    endclass
    
    // ------------------------------------------------------------------------
    // 组件：环境 - 连接 Monitor 和 Subscriber
    // ------------------------------------------------------------------------
    class env extends uvm_env;
        `uvm_component_utils(env)
        
        monitor mon;
        subscriber sub;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon = monitor::type_id::create("mon", this);
            sub = subscriber::type_id::create("sub", this);
        endfunction
        
        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            mon.ap.connect(sub.imp);  // 连接 Analysis Port
        endfunction
    endclass
    
    // ------------------------------------------------------------------------
    // 测试程序
    // ------------------------------------------------------------------------
    initial begin
        env e;
        
        $display("========================================");
        $display("  UVM Analysis Port Demo");
        $display("========================================");
        
        e = env::type_id::create("env", null);
        e.build();
        e.connect();
        
        run_test();
        
        $display("\nAnalysis ports testbench Complete!");
    end
    
    // ------------------------------------------------------------------------
    // 波形记录
    // ------------------------------------------------------------------------
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_analysis);
    end
    
endmodule
