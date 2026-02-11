// ============================================================================
// Complete Coverage Model - 完整覆盖率模型
// ============================================================================

`include "uvm_macros.svh"

class soc_coverage_model extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(soc_coverage_model)
    
    // Coverage Groups
    covergroup addr_cg;
        ADDR_BANK0: coverpoint trans.addr {
            bins LOW = {[0:'hFFFF]};
            bins BANK1 = {['h10000:'h1FFFFF]};
            bins BANK2 = {['h20000:'h3FFFFF]};
            bins HIGH = {['h40000:$]};
        }
    endgroup
    
    covergroup data_cg;
        DATA_ZERO: coverpoint trans.data { bins zero = {0}; }
        DATA_MAX: coverpoint trans.data { bins max = {'hFFFFFFFF}; }
        DATA_RAND: coverpoint trans.data { bins random[] = {[1:'hFFFFFFFE]}; }
    endgroup
    
    covergroup rw_cg;
        READ: coverpoint trans.is_read { bins read = {1}; }
        WRITE: coverpoint trans.is_read { bins write = {0}; }
    endgroup
    
    covergroup addr_rw_cg;
        CROSS: cross ADDR_BANK0, rw_cg;
    endgroup
    
    // Coverage metrics
    real addr_coverage = 0;
    real data_coverage = 0;
    real rw_coverage = 0;
    real overall_coverage = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        addr_cg = new();
        data_cg = new();
        rw_cg = new();
        addr_rw_cg = new();
    endfunction
    
    virtual function void write(bus_trans t);
        void'(addr_cg.sample());
        void'(data_cg.sample());
        void'(rw_cg.sample());
        void'(addr_rw_cg.sample());
        
        addr_coverage = addr_cg.get_inst_coverage();
        data_coverage = data_cg.get_inst_coverage();
        rw_coverage = rw_cg.get_inst_coverage();
        overall_coverage = (addr_coverage + data_coverage + rw_coverage) / 3;
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("COV", 
            $sformatf("Addr: %0.1f%%, Data: %0.1f%%, RW: %0.1f%%, Overall: %0.1f%%",
                addr_coverage, data_coverage, rw_coverage, overall_coverage), UVM_LOW)
    endfunction
endclass

endmodule
