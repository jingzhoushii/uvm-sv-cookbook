// ============================================================================
// Full UVM Phases Example
// ============================================================================
`timescale 1ns/1ps
class my_comp extends uvm_component; `uvm_component_utils(my_comp)
    function new(string n, uvm_component p); super.new(n,p); $display("[%0t] [%s] new()",$time,n); endfunction
    virtual function void build_phase(uvm_phase p); super.build_phase(p); $display("[%0t] [%s] build_phase()",$time,get_full_name()); endfunction
    virtual function void connect_phase(uvm_phase p); super.connect_phase(p); $display("[%0t] [%s] connect_phase()",$time,get_full_name()); endfunction
    virtual function void end_of_elaboration_phase(uvm_phase p); super.end_of_elaboration_phase(p); $display("[%0t] [%s] end_of_elaboration()",$time,get_full_name()); endfunction
    virtual task run_phase(uvm_phase p); $display("[%0t] [%s] run_phase() START",$time,get_full_name()); phase.raise_objection(this); #100; phase.drop_objection(this); $display("[%0t] [%s] run_phase() END",$time,get_full_name()); endtask
    virtual function void report_phase(uvm_phase p); super.report_phase(p); $display("[%0t] [%s] report_phase()",$time,get_full_name()); endfunction
    virtual function void final_phase(uvm_phase p); super.final_phase(p); $display("[%0t] [%s] final_phase()",$time,get_full_name()); endfunction
endclass
module tb_phases; initial begin my_comp e,a,b; e=new("env",null); a=new("agent",e); b=new("driver",e); #300; $display("Done"); $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_phases); end endmodule
