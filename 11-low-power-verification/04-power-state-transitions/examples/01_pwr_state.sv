`timescale 1ns/1ps
typedef enum {ON, OFF, RET} pwr_state_e;
class pwr_statemachine extends uvm_component;
    `uvm_component_utils(pwr_statemachine) pwr_state_e state;
    function new(string n,uvm_component p);super.new(n,p);state=OFF;endfunction
    task transition(pwr_state_e next);
        `uvm_info("PWR",$sformatf("%s -> %s",state.name(),next.name()),UVM_LOW)
        state = next;
    endtask
endclass
module tb; initial begin pwr_statemachine psm; psm=new("psm",null); psm.transition(ON); #10; psm.transition(RET); #10; psm.transition(OFF); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
