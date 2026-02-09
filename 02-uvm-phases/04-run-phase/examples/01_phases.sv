// ============================================================
// File: 01_phases.sv
// Description: UVM Phases 示例
// ============================================================

`timescale 1ns/1ps

class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        $display("[%0t] %s new()", $time, name);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("[%0t] %s build_phase()", $time, get_full_name());
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("[%0t] %s connect_phase()", $time, get_full_name());
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        $display("[%0t] %s end_of_elaboration_phase()", $time, get_full_name());
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        $display("[%0t] %s run_phase() - Starting", $time, get_full_name());
        phase.raise_objection(this);
        #50;
        phase.drop_objection(this);
        $display("[%0t] %s run_phase() - Finished", $time, get_full_name());
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("[%0t] %s report_phase()", $time, get_full_name());
    endfunction
    
    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        $display("[%0t] %s final_phase()", $time, get_full_name());
    endfunction
endclass

module tb_phases;
    my_env e;
    
    initial begin
        e = my_env::type_id::create("e", null);
        #200;
        $display("");
        $display("========================================");
        $display("  Phases Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_phases);
    end
endmodule
