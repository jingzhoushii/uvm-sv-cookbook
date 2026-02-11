// ============================================================================
// Advanced Callback - Error Injection
// ============================================================================

`include "uvm_macros.svh"

// ==========================================
// 错误注入回调
// ==========================================
class error_inject_callback extends uvm_callback;
    `uvm_object_utils(error_inject_callback)
    
    typedef enum {NONE, ADDR_ERROR, DATA_ERROR, TIMEOUT} 
        error_type_t;
    
    error_type_t inject_type = DATA_ERROR;
    int error_rate = 10;  // 10% 错误率
    
    int error_count = 0;
    
    virtual task pre_send(uvm_driver#(bus_trans) drv, 
                          bus_trans tr);
        if ($urandom_range(100) < error_rate) begin
            case (inject_type)
                ADDR_ERROR: tr.addr[0] = 1'bx;
                DATA_ERROR: tr.data = '0;
                TIMEOUT: begin
                    fork
                        begin
                            #100;
                            if (tr.data !== 'x)
                                tr.data = 'x;
                        end
                    join_none
                end
            endcase
            error_count++;
            `uvm_warning("ERR_INJECT", 
                $sformatf("Injected %0s error #%0d", 
                    inject_type.name(), error_count))
        end
    endtask
endclass

// ==========================================
// 覆盖率回调
// ==========================================
class coverage_callback extends uvm_callback;
    `uvm_object_utils(coverage_callback)
    
    int total_trans = 0;
    int read_trans = 0;
    int write_trans = 0;
    
    covergroup trans_cg;
        RW: coverpoint is_read;
        ADDR: coverpoint addr[3] {
            bins LOW = {0,1,2};
            bins HIGH = {3,4,5,6,7};
        }
        CROSS: cross RW, ADDR;
    endgroup
    
    function new(string name="coverage_cb");
        super.new(name);
        trans_cg = new();
    endfunction
    
    virtual task pre_send(uvm_driver#(bus_trans) drv, 
                          bus_trans tr);
        total_trans++;
        if (tr.is_read) read_trans++;
        else write_trans++;
        void'(trans_cg.sample());
    endtask
    
    virtual function void report();
        real cov = trans_cg.get_inst_coverage();
        `uvm_info("COV", 
            $sformatf("Coverage: %0.1f%%, R: %0d, W: %0d", 
                cov, read_trans, write_trans), UVM_LOW)
    endfunction
endclass

// ==========================================
// Driver with Callbacks
// ==========================================
class monitored_driver extends uvm_driver#(bus_trans);
    `uvm_component_utils(monitored_driver)
    
    typedef uvm_callbacks#(monitored_driver) cb_pool_t;
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            cb_pool_t::pre_send(this, req);
            drive(req);
            cb_pool_t::post_send(this, req);
            seq_item_port.item_done();
        end
    endtask
    
    virtual protected void drive(bus_trans t);
        #1ns;
    endfunction
endclass

// ==========================================
// Test with Multiple Callbacks
// ==========================================
class advanced_callback_test extends uvm_test;
    `uvm_component_utils(advanced_callback_test)
    
    monitored_driver drv;
    error_inject_callback err_cb;
    coverage_callback cov_cb;
    
    virtual function void build_phase(uvm_phase phase);
        drv = monitored_driver::type_id::create("drv", this);
        
        // 添加错误注入回调
        err_cb = new("err_cb");
        err_cb.inject_type = error_inject_callback::DATA_ERROR;
        err_cb.error_rate = 15;
        uvm_callbacks#(monitored_driver)::add(drv, err_cb);
        
        // 添加覆盖率回调
        cov_cb = new("cov_cb");
        uvm_callbacks#(monitored_driver)::add(drv, cov_cb);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info("TEST", "All registered callbacks:", UVM_LOW)
        uvm_callbacks#(monitored_driver)::display();
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        #1000;
        phase.phase_done.drop_objection(this);
    endtask
    
    virtual function void report();
        `uvm_info("TEST_REPORT", 
            $sformatf("Errors injected: %0d", 
                err_cb.error_count), UVM_LOW)
    endfunction
endclass

module tb_error_injection;
    initial begin
        run_test("advanced_callback_test");
    end
endmodule
