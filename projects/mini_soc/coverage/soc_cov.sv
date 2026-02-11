// ============================================================================
// SoC Coverage Model
// ============================================================================

`include "uvm_macros.svh"

class soc_coverage_model extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(soc_coverage_model)
    
    // Transaction Coverage
    covergroup trans_cg;
        ADDR: coverpoint trans.addr {
            bins KB_0_4 = {[0:'h1000]};
            bins KB_4_16 = {['h1000:'h4000]};
            bins MB_16_512 = {['h4000:'h20000000]};
            bins HIGH = {['h20000000:$]};
        }
        DATA: coverpoint trans.data {
            bins ZERO = {0};
            bins ALL_ONES = {'hFFFFFFFF};
            bins RANDOM = default;
        }
        READ_WRITE: coverpoint trans.is_read {
            bins READ = {1};
            bins WRITE = {0};
        }
        CROSS: cross ADDR, READ_WRITE;
    endgroup
    
    // Bus Transfer Coverage
    covergroup bus_transfer_cg;
        SIZE: coverpoint trans.hsize {
            bins BYTE = {0};
            bins HALF = {1};
            bins WORD = {2};
        }
        BURST: coverpoint trans.hburst {
            bins SINGLE = {0};
            bins INCR = {1};
        }
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        trans_cg = new();
        bus_transfer_cg = new();
    endfunction
    
    virtual function void write(bus_trans t);
        void'(trans_cg.sample());
        void'(bus_transfer_cg.sample());
    endfunction
endclass

// Coverage Report
class cov_report extends uvm_subscriber;
    `uvm_component_utils(cov_report)
    
    real bus_coverage;
    real uart_coverage;
    real overall_coverage;
    
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("COV_REPORT", $sformatf("Bus Coverage: %0.2f%%", bus_coverage), UVM_LOW)
        `uvm_info("COV_REPORT", $sformatf("UART Coverage: %0.2f%%", uart_coverage), UVM_LOW)
        `uvm_info("COV_REPORT", $sformatf("Overall: %0.2f%%", overall_coverage), UVM_LOW)
    endfunction
endclass

endmodule
