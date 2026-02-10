// ============================================================================
// Full RAL Backdoor Access Example
// ============================================================================
`timescale 1ns/1ps
class bd_blk extends uvm_reg_block; uvm_reg r;
    virtual function void build();
        r=uvm_reg::type_id::create("r"); r.build();
        r.add_hdl_path("tb.dut.reg"); r.configure(this);
        default_map=create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(r,'h0,"RW");
    endfunction
endclass
module tb_bd; reg [31:0] reg=0; initial begin bd_blk b; b=new(); b.build(); b.lock_model(); uvm_status_e s; b.r.poke(s,32'hDEAD); b.r.peek(s,d); $display("peek=0x%0h",d); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_bd); end endmodule
