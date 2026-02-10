// ============================================================================
// Full RAL Access Methods Example
// ============================================================================
`timescale 1ns/1ps
class blk extends uvm_reg_block; uvm_reg r; virtual function void build(); r=uvm_reg::type_id::create("r"); r.build(); r.configure(this,0,32'h0000_0000,UVM_DEFAULT,"RW",0,32'h1234_5678); default_map=create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(r,'h0,"RW"); endfunction endclass
module tb_ra; initial begin blk b; b=new(); b.build(); b.lock_model(); uvm_status_e s; uvm_reg_data_t d; b.r.write(s,32'hAAAA); b.r.read(s,d); $display("read=%0h",d); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_ra); end endmodule
