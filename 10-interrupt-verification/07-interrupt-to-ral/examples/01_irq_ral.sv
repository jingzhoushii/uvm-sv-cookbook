`timescale 1ns/1ps
class irq_rm extends uvm_reg_block;
    uvm_reg irq_en, irq_status;
    virtual function void build();
        irq_en = uvm_reg::type_id::create("irq_en"); irq_en.build(); irq_en.configure(this);
        irq_status = uvm_reg::type_id::create("irq_status"); irq_status.build(); irq_status.configure(this);
        default_map = create_map("m",0,4,UVM_LITTLE_ENDIAN);
        default_map.add_reg(irq_en,'h0,"RW"); default_map.add_reg(irq_status,'h4,"RC");
    endfunction
endclass
module tb; initial begin irq_rm rm; rm=new(); rm.build(); rm.lock_model(); uvm_reg_data_t d; rm.irq_en.write(status,32'hF); rm.irq_en.read(status,d); $display("IRQ enabled"); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
