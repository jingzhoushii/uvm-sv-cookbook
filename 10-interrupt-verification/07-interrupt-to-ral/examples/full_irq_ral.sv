// ============================================================================
// Full Interrupt to RAL Example
// ============================================================================
`timescale 1ns/1ps
class irq_ral extends uvm_reg_block; uvm_reg irq_en, irq_st;
    virtual function void build();
        irq_en=uvm_reg::type_id::create("irq_en"); irq_en.build(); irq_en.configure(this);
        irq_st=uvm_reg::type_id::create("irq_st"); irq_st.build(); irq_st.configure(this);
        default_map=create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(irq_en,'h0,"RW"); default_map.add_reg(irq_st,'h4,"RC");
    endfunction
endclass
module tb_iral; initial begin irq_ral r; r=new(); r.build(); r.lock_model(); uvm_status_e s; r.irq_en.write(s,32'hFF); $display("IRQ enabled"); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_iral); end endmodule
