// ============================================================================
// Full RAL Coverage Example
// ============================================================================
`timescale 1ns/1ps
class cov_blk extends uvm_reg_block; uvm_reg r; covergroup cg; coverpoint r.value[1:0] { bins mode[]={0,1,2,3}; }
    virtual function void build(); r=uvm_reg::type_id::create("r"); r.build(); r.configure(this,0,32'h0000_0000,UVM_DEFAULT,"RW",0,32'h0); cg=new(); default_map=create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(r,'h0,"RW"); endfunction
endclass
module tb_rcov; initial begin cov_blk b; b=new(); b.build(); b.lock_model(); repeat(10) begin b.cg.sample(); #10; end $display("Coverage: %.1f%%",b.cg.get_coverage()); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_rcov); end endmodule
