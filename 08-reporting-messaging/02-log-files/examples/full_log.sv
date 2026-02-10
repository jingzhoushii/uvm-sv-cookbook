// ============================================================================
// Full Log Files Example
// ============================================================================
`timescale 1ns/1ps
class log_demo extends uvm_component; `uvm_component_utils(log_demo) int logf;
    function new(string n, uvm_component p); super.new(n,p); endfunction
    virtual function void build_phase(uvm_phase p); super.build_phase(p); logf=$fopen("sim.log"); set_report_file_object(logf); set_report_severity_action(UVM_INFO,UVM_DISPLAY|UVM_LOG); endfunction
    virtual task run_phase(uvm_phase p); phase.raise_objection(this); `uvm_info("LOG","Test message 1",UVM_LOW) `uvm_info("LOG","Test message 2",UVM_LOW) #50; phase.drop_objection(this); endtask
    virtual function void final_phase(uvm_phase p); super.final_phase(p); if(logf) $fclose(logf); endfunction
endclass
module tb_log; initial begin log_demo l; l=new("l",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_log); end endmodule
