// ============================================================
// File: 01_config_db.sv
// Description: UVM Config DB 示例
// ============================================================

`timescale 1ns/1ps

interface my_if;
    logic [31:0] data;
endinterface

class component_a extends uvm_component;
    `uvm_component_utils(component_a)
    
    virtual my_if vif;
    int count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 从 config_db 获取虚接口
        if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", "Cannot get vif")
        end
        
        // 从 config_db 获取配置
        void'(uvm_config_db#(int)::get(this, "", "count", count));
        
        `uvm_info(get_type_name(), 
            $sformatf("Got vif and count=%0d", count), UVM_LOW)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module tb_config_db;
    my_if vif();
    
    initial begin
        $display("========================================");
        $display("  UVM Config DB Demo");
        $display("========================================");
        $display("");
        
        // 在 config_db 中设置虚接口
        uvm_config_db#(virtual my_if)::set(null, "*", "vif", vif);
        
        // 在 config_db 中设置配置
        uvm_config_db#(int)::set(null, "*", "count", 42);
        
        // 运行测试
        component_a comp;
        comp = new("comp", null);
        comp.build();
        
        #150;
        
        $display("");
        $display("========================================");
        $display("  Config DB Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_config_db);
    end
    
endmodule
