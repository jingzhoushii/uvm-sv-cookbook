// ============================================================================
// Full RAL Example
// ============================================================================
`timescale 1ns/1ps

class my_reg extends uvm_reg;
    uvm_reg_field enable, mode;
    function new(string n="my_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
    virtual function void build();
        enable = uvm_reg_field::type_id::create("enable"); enable.configure(this,1,0,"RW",0,1'b0,1,1,0);
        mode = uvm_reg_field::type_id::create("mode"); mode.configure(this,2,1,"RW",0,2'b00,1,1,0);
    endfunction
endclass

class my_block extends uvm_reg_block;
    my_reg r;
    virtual function void build();
        r = my_reg::type_id::create("r"); r.build(); r.configure(this);
        default_map = create_map("m",0,4,UVM_LITTLE_ENDIAN); default_map.add_reg(r,'h0,"RW");
    endfunction
endclass

module tb_ral;
    initial begin
        my_block b; b=new(); b.build(); b.lock_model();
        uvm_status_e s; uvm_reg_data_t d;
        b.r.enable.write(s,1'b1); `uvm_info("RAL","Write enable",UVM_LOW)
        b.r.mode.write(s,2'b10); `uvm_info("RAL","Write mode",UVM_LOW)
        b.r.enable.read(s,d); `uvm_info("RAL",$sformatf("Read enable=%0d",d),UVM_LOW)
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_ral); end
endmodule
