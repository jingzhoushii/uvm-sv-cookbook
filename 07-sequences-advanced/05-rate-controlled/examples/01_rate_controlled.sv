// ============================================================================
// Rate-Controlled Sequences
// ============================================================================

`timescale 1ns/1ps

class trans extends uvm_sequence_item;
    rand bit [31:0] addr, data;
    `uvm_object_utils_begin(trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class rate_limit_seq extends uvm_sequence#(trans);
    `uvm_object_utils(rate_limit_seq)
    time min_gap = 10ns;
    virtual task body();
        forever begin
            `uvm_do(req)
            #(min_gap);
        end
    endtask
endclass

class driver extends uvm_driver#(trans);
    `uvm_component_utils(driver)
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            seq_item_port.get_next_item(req);
            #10;
            seq_item_port.item_done(req);
        end
        phase.drop_objection(this);
    endtask
endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    driver drv;
    uvm_sequencer#(trans) seqr;
    virtual function void build_phase(uvm_phase phase);
        drv = driver::type_id::create("drv", this);
        seqr = uvm_sequencer#(trans)::type_id::create("seqr", this);
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

module tb_rate;
    initial begin
        $display("Rate-Controlled Demo");
        run_test();
        #1000; $finish;
    end
endmodule
