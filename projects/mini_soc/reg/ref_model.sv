// ============================================================================
// Reference Model - 参考模型
// ============================================================================

`include "uvm_macros.svh"

class bus_ref_model extends uvm_component;
    `uvm_component_utils(bus_ref_model)
    
    bit [31:0] mem[bit [31:0]];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void predict(bus_trans t);
        if (!t.is_read) begin
            mem[t.addr] = t.data;
            `uvm_info("REF", $sformatf("Write: addr=0x%0h data=0x%0h", t.addr, t.data), UVM_LOW)
        end else begin
            if (mem.exists(t.addr))
                t.data = mem[t.addr];
            else
                t.data = 32'h0;
        end
    endfunction
endclass

class soc_ref_model extends uvm_component;
    `uvm_component_utils(soc_ref_model)
    
    bus_ref_model bus_ref;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        bus_ref = bus_ref_model::type_id::create("bus_ref", this);
    endfunction
endclass

endmodule
