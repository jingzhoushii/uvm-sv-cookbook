// ============================================================================
// @file    : axi_monitor.sv
// @brief   : AXI Monitor
// @note    : 采样信号转换为事务
// ============================================================================

`timescale 1ns/1ps

class axi_monitor extends uvm_monitor;
    `uvm_component_utils(axi_monitor)
    
    // 虚拟接口
    virtual axi_if             vif;
    
    // 分析端口
    uvm_analysis_port#(axi_transaction) ap;
    
    // 统计
    int                        num_monitored;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        num_monitored = 0;
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        
        if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", "Cannot get axi_if")
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        `uvm_info(get_type_name(), "Starting monitor", UVM_LOW)
        
        forever begin
            // 监听 WRITE
            fork
                monitor_write();
                monitor_read();
            join_any
            disable fork;
        end
    endtask
    
    protected task monitor_write();
        axi_transaction tr;
        
        // 等待 AWVALID & AWREADY
        @(posedge vif.clk);
        while (!vif.awvalid || !vif.awready) @(posedge vif.clk);
        
        tr = axi_transaction::type_id::create("tr");
        tr.rw_type = WRITE;
        tr.addr = vif.awaddr;
        tr.len = vif.awlen;
        tr.size = vif.awsize;
        tr.burst = vif.awburst;
        tr.id = vif.awid;
        
        // 采样数据
        for (int i = 0; i <= tr.len; i++) begin
            @(posedge vif.clk);
            while (!vif.wvalid || !vif.wready) @(posedge vif.clk);
            tr.data[i] = vif.wdata;
            tr.strb[i] = vif.wstrb;
            @(negedge vif.clk);
        end
        
        // 采样响应
        @(posedge vif.clk);
        while (!vif.bvalid) @(posedge vif.clk);
        tr.resp = vif.bresp;
        
        ap.write(tr);
        num_monitored++;
        
        `uvm_info(get_type_name(), 
            $sformatf("Monitored WRITE: addr=0x%0h len=%0d", 
                     tr.addr, tr.len), UVM_LOW)
    endtask
    
    protected task monitor_read();
        axi_transaction tr;
        
        // 等待 ARVALID & ARREADY
        @(posedge vif.clk);
        while (!vif.arvalid || !vif.arready) @(posedge vif.clk);
        
        tr = axi_transaction::type_id::create("tr");
        tr.rw_type = READ;
        tr.addr = vif.araddr;
        tr.len = vif.arlen;
        tr.size = vif.arsize;
        tr.burst = vif.arburst;
        tr.id = vif.arid;
        
        // 采样数据
        for (int i = 0; i <= tr.len; i++) begin
            @(posedge vif.clk);
            while (!vif.rvalid) @(posedge vif.clk);
            tr.data[i] = vif.rdata;
            tr.resp = vif.rresp;
            @(negedge vif.clk);
        end
        
        ap.write(tr);
        num_monitored++;
        
        `uvm_info(get_type_name(), 
            $sformatf("Monitored READ: addr=0x%0h len=%0d", 
                     tr.addr, tr.len), UVM_LOW)
    endtask
    
endclass : axi_monitor
