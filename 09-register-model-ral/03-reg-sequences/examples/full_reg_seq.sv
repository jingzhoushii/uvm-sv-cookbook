// ============================================================================
// Full RAL Sequences Example
// ============================================================================
`timescale 1ns/1ps
class blk extends uvm_reg_block; uvm_reg r; virtual function void build(); r=uvm_reg::type_id::create("r"); r.build(); r.configure(this,0,32'h0000_0000,UVM_DEFAULT,"RW",0,32'h0); default_map=create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(r,'h0,"RW"); endfunction endclass
class reg_seq extends uvm_reg_sequence; `uvm_object_utils(reg_seq) blk rm;
    task body(); write_reg(rm.r,.value(32'hBBBB)); read_reg(rm.r,.value(d)); `uvm_info("SEQ",$sformatf("read=%0h",d),UVM_LOW) endtask
endclass
module tb_rseq; initial begin blk b; reg_seq s; b=new(); b.build(); b.lock_model(); s=reg_seq::type_id::create("s"); s.rm=b; s.start(null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_rseq); end endmodule
