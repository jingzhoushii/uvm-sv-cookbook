// ============================================================================
// @file    : axi_driver.sv
// @brief   : AXI Driver
// @note    : 将事务转换为信号驱动 DUT
// ============================================================================

`timescale 1ns/1ps

class axi_driver extends uvm_driver#(axi_transaction);
    `uvm_component_utils(axi_driver)
    
    // 配置
    axi_config                 cfg;
    
    // 虚拟接口
    virtual axi_if             vif;
    
    // 统计
    int                        num_driven;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        num_driven = 0;
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 获取配置
        if (!uvm_config_db#(axi_config)::get(this, "", "cfg", cfg)) begin
            `uvm_warning("NO_CFG", "Using default config")
            cfg = axi_config::type_id::create("cfg");
        end
        
        // 获取接口
        if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", "Cannot get axi_if")
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        `uvm_info(get_type_name(), "Starting driver", UVM_LOW)
        
        // 复位
        reset_signals();
        
        // 主循环
        forever begin
            seq_item_port.get_next_item(req);
            
            // 驱动事务
            drive_transaction(req);
            
            num_driven++;
            seq_item_port.item_done();
        end
    endfunction
    
    // ------------------------------------------------------------------------
    // 驱动任务
    // ------------------------------------------------------------------------
    protected task drive_transaction(axi_transaction tr);
        `uvm_info(get_type_name(), 
            $sformatf("Driving: addr=0x%0h len=%0d type=%s",
                     tr.addr, tr.len, tr.rw_type.name()), UVM_LOW)
        
        if (tr.rw_type == WRITE) begin
            drive_write(tr);
        end else begin
            drive_read(tr);
        end
    endtask
    
    // WRITE 事务
    protected task drive_write(axi_transaction tr);
        // 驱动 AW 通道
        vif.awaddr   = tr.addr;
        vif.awlen    = tr.len;
        vif.awsize   = tr.size;
        vif.awburst  = tr.burst;
        vif.awcache  = tr.cache;
        vif.awprot   = tr.prot;
        vif.awqos    = tr.qos;
        vif.awid     = tr.id;
        vif.awvalid  = 1'b1;
        
        // 等待 AWREADY
        @(posedge vif.clk);
        while (!vif.awready) @(posedge vif.clk);
        @(negedge vif.clk);
        vif.awvalid = 1'b0;
        
        // 驱动 W 通道
        for (int i = 0; i <= tr.len; i++) begin
            vif.wdata  = tr.data[i];
            vif.wstrb  = tr.strb[i];
            vif.wlast  = (i == tr.len);
            vif.wvalid = 1'b1;
            
            @(posedge vif.clk);
            while (!vif.wready) @(posedge vif.clk);
            @(negedge vif.clk);
        end
        vif.wvalid = 1'b0;
        vif.wlast  = 1'b0;
        
        // 等待 B 通道
        @(posedge vif.clk);
        while (!vif.bvalid) @(posedge vif.clk);
        tr.resp = vif.bresp;
        @(negedge vif.clk);
        
        `uvm_info(get_type_name(), 
            $sformatf("Write complete: resp=%0d", tr.resp), UVM_LOW)
    endtask
    
    // READ 事务
    protected task drive_read(axi_transaction tr);
        // 驱动 AR 通道
        vif.araddr   = tr.addr;
        vif.arlen    = tr.len;
        vif.arsize   = tr.size;
        vif.arburst  = tr.burst;
        vif.arcache  = tr.cache;
        vif.arprot   = tr.prot;
        vif.arqos    = tr.qos;
        vir.arid     = tr.id;
        vif.arvalid  = 1'b1;
        
        // 等待 ARREADY
        @(posedge vif.clk);
        while (!vif.arready) @(posedge vif.clk);
        @(negedge vif.clk);
        vif.arvalid = 1'b0;
        
        // 接收 R 通道
        for (int i = 0; i <= tr.len; i++) begin
            @(posedge vif.clk);
            while (!vif.rvalid) @(posedge vif.clk);
            tr.data[i] = vif.rdata;
            tr.resp = vif.rresp;
            if (i == tr.len) tr.last = 1'b1;
            @(negedge vif.clk);
        end
        
        `uvm_info(get_type_name(), 
            $sformatf("Read complete: data=0x%0h resp=%0d", 
                     tr.data[0], tr.resp), UVM_LOW)
    endtask
    
    // 复位
    protected task reset_signals();
        vif.awvalid = 1'b0;
        vif.awaddr  = 0;
        vif.wvalid  = 1'b0;
        vif.wdata   = 0;
        vif.wlast   = 1'b0;
        vif.arvalid = 1'b0;
        vif.araddr  = 0;
    endtask
    
endclass : axi_driver
