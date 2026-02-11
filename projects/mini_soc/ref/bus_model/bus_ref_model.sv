// ============================================================================
// Bus Reference Model - 总线参考模型
// ============================================================================

`include "uvm_macros.svh"

class bus_ref_model extends uvm_component;
    `uvm_component_utils(bus_ref_model)
    
    // 内存映像
    bit [31:0] mem[bit [31:0]];
    
    // Analysis port
    uvm_analysis_export#(bus_trans) in;
    uvm_analysis_port#(bus_trans) out;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void write(bus_trans t);
        // 预测行为
        if (!t.is_read) begin
            mem[t.addr] = t.data;
            `uvm_info("BUS_REF", $sformatf("Write: addr=0x%0h data=0x%0h", t.addr, t.data), UVM_LOW)
        end else begin
            if (mem.exists(t.addr))
                t.data = mem[t.addr];
            else
                t.data = 32'h0;
            `uvm_info("BUS_REF", $sformatf("Read: addr=0x%0h data=0x%0h", t.addr, t.data), UVM_LOW)
        end
        out.write(t);
    endfunction
endclass

endmodule
