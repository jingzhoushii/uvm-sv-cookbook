// ============================================================================
// Basic Callback Example - UVM 回调基础示例
// ============================================================================

`include "uvm_macros.svh"

// ==========================================
// 1. 定义回调类
// ==========================================
class driver_callback extends uvm_callback;
    `uvm_object_utils(driver_callback)
    
    int transaction_count = 0;
    
    // 前置回调
    virtual task pre_send(uvm_driver#(bus_trans) drv, 
                          bus_trans tr);
        `uvm_info("CB_PRE", 
            $sformatf("Transaction %0d: %s", 
                transaction_count, tr.convert2str()), 
            UVM_LOW)
    endtask
    
    // 后置回调
    virtual task post_send(uvm_driver#(bus_trans) drv,
                           bus_trans tr);
        transaction_count++;
        `uvm_info("CB_POST", 
            $sformatf("Transaction %0d completed", 
                transaction_count-1), 
            UVM_LOW)
    endtask
endclass

// ==========================================
// 2. Driver with Callbacks
// ==========================================
class callback_driver extends uvm_driver#(bus_trans);
    `uvm_component_utils(callback_driver)
    
    // 声明回调池
    typedef uvm_callbacks#(callback_driver, 
                           driver_callback) cb_pool_t;
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            
            // 调用前置回调
            cb_pool_t::pre_send(this, req);
            
            drive(req);
            
            // 调用后置回调
            cb_pool_t::post_send(this, req);
            
            seq_item_port.item_done();
        end
    endtask
    
    virtual protected void drive(bus_trans t);
        // 基本驱动逻辑
        #1ns;
    endfunction
endclass

// ==========================================
// 3. 测试
// ==========================================
class basic_callback_test extends uvm_test;
    `uvm_component_utils(basic_callback_test)
    
    callback_driver drv;
    driver_callback cb;
    
    virtual function void build_phase(uvm_phase phase);
        drv = callback_driver::type_id::create("drv", this);
        
        // 创建并注册回调
        cb = new("my_cb");
        uvm_callbacks#(callback_driver)::add(drv, cb);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info("TEST", "Registered callbacks:", UVM_LOW)
        uvm_callbacks#(callback_driver)::display();
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        #500;
        
        // 动态添加另一个回调
        driver_callback cb2 = new("cb2");
        uvm_callbacks#(callback_driver)::add(drv, cb2);
        
        #500;
        
        // 移除第一个回调
        uvm_callbacks#(callback_driver)::delete(drv, cb);
        
        #500;
        phase.phase_done.drop_objection(this);
    endtask
    
    virtual function void report();
        `uvm_info("TEST", 
            $sformatf("Total transactions: %0d", 
                cb.transaction_count), UVM_LOW)
    endfunction
endclass

module tb_basic_callback;
    initial begin
        run_test("basic_callback_test");
    end
endmodule
