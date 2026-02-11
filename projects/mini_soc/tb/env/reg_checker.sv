// ============================================================================
// Register Checker - 寄存器检查器
// ============================================================================

`include "uvm_macros.svh"

class reg_checker extends uvm_component;
    `uvm_component_utils(reg_checker)
    
    // 寄存器定义
    typedef struct {
        bit [31:0] addr;
        bit [31:0] mask;
        bit [31:0] reset_val;
        string name;
    } reg_info_t;
    
    reg_info_t regs[string];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 注册标准寄存器
        regs["UART_CTRL"] = '{addr: 32'h2000_0008, mask: 32'h0000_00FF, reset_val: 32'h0, name: "UART_CTRL"};
        regs["UART_STAT"] = '{addr: 32'h2000_0004, mask: 32'h0000_00FF, reset_val: 32'h0, name: "UART_STAT"};
        regs["TIMER_CTRL"] = '{addr: 32'h3000_0008, mask: 32'h0000_00FF, reset_val: 32'h0, name: "TIMER_CTRL"};
    endfunction
    
    virtual function void check_register(string name, bit [31:0] value);
        if (!regs.exists(name)) begin
            `uvm_warning("REG", $sformatf("Unknown register: %s", name))
            return;
        end
        
        reg_info_t r = regs[name];
        bit [31:0] expected = value & r.mask;
        bit [31:0] actual_reset = r.reset_val & r.mask;
        
        if (expected != actual_reset) begin
            `uvm_error("REG_FAIL", 
                $sformatf("%s: Expected 0x%0h, Got 0x%0h", 
                    name, actual_reset, expected))
        end else begin
            `uvm_info("REG_PASS", 
                $sformatf("%s: OK (0x%0h)", name, value), UVM_LOW)
        end
    endfunction
endclass

endmodule
