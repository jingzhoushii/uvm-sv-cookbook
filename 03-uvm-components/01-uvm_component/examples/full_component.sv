// ============================================================================
// Full UVM Component Example
// ============================================================================
`timescale 1ns/1ps
class my_comp extends uvm_component; `uvm_component_utils(my_comp)
    int id; static int count=0;
    function new(string n, uvm_component p); super.new(n,p); id=count++; $display("[%0t] [%s] id=%0d",$time,n,id); endfunction
    virtual function void build_phase(uvm_phase p); super.build_phase(p); $display("[%0t] [%s] build() depth=%0d",$time,get_full_name(),get_depth()); endfunction
    virtual task run_phase(uvm_phase p); phase.raise_objection(this); #50; phase.drop_objection(this); endtask
endclass
module tb_comp; initial begin my_comp p,c1,c2; p=new("parent",null); c1=new("child1",p); c2=new("child2",p); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_comp); end endmodule
