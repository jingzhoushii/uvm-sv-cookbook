// ============================================================================
// Full RAL Reset Example
// ============================================================================
`timescale 1ns/1ps
class rst_blk extends uvm_reg_block; uvm_reg r;
    virtual function void build();
        r=uvm_reg::type_id::create("r"); r.build();
        r.add_hdl_path("tb.dut.r"); r.configure(this,0,32'h0000_0000,UVM_DEFAULT,"RW",0,32'h1234_5678);
        default_map=create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(r,'h0,"RW");
    endfunction
endclass
module tb_rrst; reg [31:0] r=32'h1234_5678; initial begin rst_blk b; b=new(); b.build(); b.lock_model(); uvm_status_e s; b.r.mirror(s,UVM_CHECK); $display("Reset value checked"); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_rrst); end endmodule
