// ============================================================================
// @file    : coverage_model.sv
// @brief   : 通用覆盖率模型
// @note    : 可复用的覆盖率定义
// ============================================================================

`timescale 1ns/1ps

// ============================================================================
// 1. 事务覆盖率
// ============================================================================
class transaction_coverage extends uvm_component;
    `uvm_component_utils(transaction_coverage)
    
    // 配置
    axi_config cfg;
    
    // 覆盖率组
    covergroup cg_transaction;
        cp_addr: coverpoint cfg.base_addr {
            bins low    = {[0:32'h0000_FFFF]};
            bins mid    = {[32'h0001_0000:32'h0FFF_FFFF]};
            bins high   = {[32'h1000_0000:32'hFFFF_FFFF]};
        }
        cp_len: coverpoint cfg.max_transaction_length {
            bins short = {[0:4]};
            bins medium = {[5:8]};
            bins long = {[9:16]};
        }
    endgroup
    
    // 交叉覆盖
    covergroup cg_cross;
        cp_op: coverpoint cfg.is_active {
            bins active = {UVM_ACTIVE};
            bins passive = {UVM_PASSIVE};
        }
        cp_type: coverpoint cfg.num_transactions {
            bins few = {[10:50]};
            bins many = {[51:100]};
        }
        cross_op_type: cross cp_op, cp_type;
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_transaction = new();
        cg_cross = new();
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        forever begin
            // 采样覆盖率
            cg_transaction.sample();
            cg_cross.sample();
            #100;
        end
        
        phase.drop_objection(this);
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("COVERAGE",
            $sformatf("Transaction coverage: %.1f%%",
                     cg_transaction.get_coverage()), UVM_LOW)
        `uvm_info("COVERAGE",
            $sformatf("Cross coverage: %.1f%%",
                     cg_cross.get_coverage()), UVM_LOW)
    endfunction
endclass : transaction_coverage

// ============================================================================
// 2. 总线协议覆盖率
// ============================================================================
class protocol_coverage extends uvm_component;
    `uvm_component_utils(protocol_coverage)
    
    // 事务分析导入
    uvm_analysis_imp#(axi_transaction, protocol_coverage) imp;
    
    // 覆盖率组
    covergroup cg_addr;
        cp_addr: coverpoint addr {
            bins addr_bins[] = {[0:32'hFFFF_FFFF]};
        }
    endgroup
    
    covergroup cg_burst;
        cp_len: coverpoint len {
            bins len1 = {0};
            bins len4 = {[1:4]};
            bins len8 = {[5:8]};
            bins len16 = {[9:15]};
        }
        cp_size: coverpoint size {
            bins size1 = {0};
            bins size2 = {1};
            bins size4 = {2};
        }
        cp_burst: coverpoint burst {
            bins fixed = {0};
            bins incr = {1};
            bins wrap = {2};
        }
        cross_len_size: cross cp_len, cp_size;
        cross_all: cross cp_len, cp_size, cp_burst;
    endgroup
    
    covergroup cg_rw;
        cp_rw: coverpoint rw_type {
            bins read = {READ};
            bins write = {WRITE};
        }
    endgroup
    
    // 变量
    bit [31:0] addr;
    bit [7:0] len;
    bit [2:0] size;
    bit [1:0] burst;
    rw_e rw_type;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
        cg_addr = new();
        cg_burst = new();
        cg_rw = new();
    endfunction
    
    virtual function void write(axi_transaction tr);
        addr = tr.addr;
        len = tr.len;
        size = tr.size;
        burst = tr.burst;
        rw_type = tr.rw_type;
        
        cg_addr.sample();
        cg_burst.sample();
        cg_rw.sample();
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("PROTOCOL_COV",
            $sformatf("Address coverage: %.1f%%",
                     cg_addr.get_coverage()), UVM_LOW)
        `uvm_info("PROTOCOL_COV",
            $sformatf("Burst coverage: %.1f%%",
                     cg_burst.get_coverage()), UVM_LOW)
    endfunction
endclass : protocol_coverage

// ============================================================================
// 3. 功能覆盖率（通用）
// ============================================================================
class functional_coverage extends uvm_component;
    `uvm_component_utils(functional_coverage)
    
    // 配置覆盖
    covergroup cg_config;
        cp_active: coverpoint is_active {
            bins active = {1};
            bins passive = {0};
        }
        cp_num_tx: coverpoint num_tx {
            bins low = {[10:50]};
            bins high = {[51:100]};
        }
        cp_addr_range: coverpoint addr_range {
            bins low = {[0:32'h00FF_FFFF]};
            bins high = {[32'h0100_0000:32'hFFFF_FFFF]};
        }
    endgroup
    
    // 事务覆盖
    covergroup cg_txn;
        cp_direction: coverpoint direction {
            bins read = {0};
            bins write = {1};
        }
        cp_length: coverpoint length {
            bins single = {0};
            bins burst = {[1:15]};
        }
    endgroup
    
    // 变量
    bit is_active;
    int num_tx;
    bit [31:0] addr_range;
    bit direction;
    bit [7:0] length;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_config = new();
        cg_txn = new();
    endfunction
    
    function void sample_config(bit active, int tx, bit [31:0] range);
        is_active = active;
        num_tx = tx;
        addr_range = range;
        cg_config.sample();
    endfunction
    
    function void sample_tx(bit dir, bit [7:0] len);
        direction = dir;
        length = len;
        cg_txn.sample();
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("FUNC_COV",
            $sformatf("Config coverage: %.1f%%",
                     cg_config.get_coverage()), UVM_LOW)
        `uvm_info("FUNC_COV",
            $sformatf("Transaction coverage: %.1f%%",
                     cg_txn.get_coverage()), UVM_LOW)
    endfunction
endclass : functional_coverage

`endif // COVERAGE_MODEL_SV
