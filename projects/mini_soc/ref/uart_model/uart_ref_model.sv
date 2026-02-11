// ============================================================================
// UART Reference Model - UART 参考模型
// ============================================================================

`include "uvm_macros.svh"

class uart_ref_model extends uvm_component;
    `uvm_component_utils(uart_ref_model)
    
    // TX FIFO
    bit [7:0] tx_fifo[$];
    bit [7:0] rx_fifo[$];
    int fifo_depth = 16;
    
    // 状态
    int tx_count = 0;
    int rx_count = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    // TX 行为
    virtual function void tx(bit [7:0] data);
        if (tx_fifo.size() < fifo_depth) begin
            tx_fifo.push_back(data);
            tx_count++;
            `uvm_info("UART_REF", $sformatf("TX: 0x%0h", data), UVM_LOW)
        end else begin
            `uvm_warning("UART_REF", "TX FIFO overflow!")
        end
    endfunction
    
    // RX 行为
    virtual function void rx(bit [7:0] data);
        if (rx_fifo.size() < fifo_depth) begin
            rx_fifo.push_back(data);
            rx_count++;
        end
    endfunction
    
    virtual function void report();
        `uvm_info("UART_REF", $sformatf("TX: %0d, RX: %0d", tx_count, rx_count), UVM_LOW)
    endfunction
endclass

endmodule
