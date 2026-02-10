// ============================================================================
// Full RAL IRQ Integration Example
// ============================================================================
`timescale 1ns/1ps
class irq_blk extends uvm_reg_block; uvm_reg en, st;
    virtual function void build();
        en=uvm_reg::type_id::create("en"); en.build(); en.configure(this);
        st=uvm_reg::type_id::create("st"); st.build(); st.configure(this);
        default_map=create_map("m",0,4,UVM_LITTLE_ENDIAN);
        default_map.add_reg(en,'h0,"RW"); default_map.add_reg(st,'h4,"RC");
    endfunction
endclass
module tb_ri; initial begin irq_blk i; i=new(); i.build(); i.lock_model(); uvm_status_e s; i.en.write(s,32'hF); $display("IRQ enabled"); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_ri); end endmodule
