// ============================================================================
// SoC Reference Model - 系统参考模型集成
// ============================================================================

`include "uvm_macros.svh"
`include "bus_model/bus_ref_model.sv"
`include "memory_model/memory_ref_model.sv"
`include "uart_model/uart_ref_model.sv"
`include "dma_model/dma_ref_model.sv"

class soc_ref_model extends uvm_component;
    `uvm_component_utils(soc_ref_model)
    
    // 子模型
    bus_ref_model     bus_ref;
    memory_ref_model  mem_ref;
    uart_ref_model   uart_ref;
    dma_ref_model    dma_ref;
    
    // Analysis port
    uvm_analysis_export#(bus_trans) bus_in;
    uvm_analysis_port#(bus_trans) bus_out;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        bus_in = new("bus_in", this);
        bus_out = new("bus_out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        bus_ref = bus_ref_model::type_id::create("bus_ref", this);
        mem_ref = memory_ref_model::type_id::create("mem_ref", this);
        uart_ref = uart_ref_model::type_id::create("uart_ref", this);
        dma_ref = dma_ref_model::type_id::create("dma_ref", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        bus_ref.out.connect(bus_out);
    endfunction
    
    // 主处理函数
    virtual function void process(bus_trans t);
        case (t.addr[31:16])
            16'h0000: bus_ref.write(t);      // CPU Stub
            16'h1000: begin                  // DMA
                if (!t.is_read) begin
                    // DMA 配置
                end
            end
            16'h2000: uart_ref.tx(t.data[7:0]);  // UART TX
            16'h3000: begin                  // Timer
                if (!t.is_read) begin
                    // Timer 配置
                end
            end
            default: bus_ref.write(t);
        endcase
    endfunction
    
    virtual function void report();
        `uvm_info("SOC_REF", "========== Reference Model Report ==========", UVM_LOW)
        mem_ref.report();
        uart_ref.report();
        dma_ref.report();
    endfunction
endclass

endmodule
