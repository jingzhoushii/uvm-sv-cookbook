// ============================================================================
// Memory Reference Model - 存储器参考模型
// ============================================================================

`include "uvm_macros.svh"

class memory_ref_model extends uvm_component;
    `uvm_component_utils(memory_ref_model)
    
    // 内存阵列
    bit [31:0] sram[bit [31:0]];
    bit [7:0]   dram[bit [31:0]];
    
    // 状态
    int writes = 0;
    int reads = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    // 写操作
    virtual function void write(bit [31:0] addr, bit [31:0] data);
        sram[addr] = data;
        writes++;
        `uvm_info("MEM_REF", $sformatf("Write: addr=0x%0h data=0x%0h", addr, data), UVM_LOW)
    endfunction
    
    // 读操作
    virtual function bit [31:0] read(bit [31:0] addr);
        if (sram.exists(addr)) begin
            reads++;
            `uvm_info("MEM_REF", $sformatf("Read: addr=0x%0h data=0x%0h", addr, sram[addr]), UVM_LOW)
            return sram[addr];
        end
        return 32'h0;
    endfunction
    
    // 统计
    virtual function void report();
        `uvm_info("MEM_REF", $sformatf("Total: writes=%0d, reads=%0d", writes, reads), UVM_LOW)
    endfunction
endclass

endmodule
