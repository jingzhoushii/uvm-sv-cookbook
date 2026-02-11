// ============================================================================
// TLM 2.0 Basic Example - 基本示例
// ============================================================================

`include "uvm_macros.svh"

typedef uvm_tlm_generic_payload gp_t;
typedef uvm_tlm_time#(1, UVM_PS) tlm_time_t;

// ==========================================
// Initiator
// ==========================================
class tlm2_basic_initiator extends uvm_component;
    `uvm_component_utils(tlm2_basic_initiator)
    
    uvm_tlm_b_transport_fw#(gp_t)::type_id::create("initiator_socket", this);
    
    bit [31:0] base_addr = 'h1000_0000;
    
    task run_phase(uvm_phase phase);
        gp_t gp;
        tlm_time_t delay = new("delay", 1.0, UVM_NS);
        
        repeat(10) begin
            gp = new("gp");
            
            // 随机事务
            gp.set_command($urandom() ? UVM_TLM_WRITE_COMMAND : UVM_TLM_READ_COMMAND);
            gp.set_address(base_addr + $urandom_range(0, 255));
            gp.set_data_size(32);  // 32 bits = 4 bytes
            
            byte data[];
            data = new[4];
            for (int i = 0; i < 4; i++)
                data[i] = $urandom();
            gp.set_data(data);
            
            `uvm_info("INIT", 
                $sformatf("Sending: addr=0x%0h cmd=%s", 
                    gp.get_address(), gp.get_command().name()), UVM_LOW)
            
            // Blocking 传输
            initiator_socket.b_transport(gp, delay);
            
            if (gp.is_response_ok())
                `uvm_info("INIT", "Response OK", UVM_LOW)
            else
                `uvm_error("INIT", "Response ERROR")
            
            #10;
        end
    endtask
endclass

// ==========================================
// Target
// ==========================================
class tlm2_basic_target extends uvm_component;
    `uvm_component_utils(tlm2_basic_target)
    
    uvm_tlm_b_transport_bw#(gp_t)::export_type_id::create("target_socket", this);
    
    // 内存阵列
    bit [7:0] mem[bit [31:0]];
    
    virtual task b_transport(gp_t gp, tlm_time_t delay);
        `uvm_info("TARGET", 
            $sformatf("Got: addr=0x%0h cmd=%s len=%0d", 
                gp.get_address(), gp.get_command().name(), 
                gp.get_data_size()), UVM_LOW)
        
        if (gp.get_command() == UVM_TLM_WRITE_COMMAND) begin
            byte data[];
            gp.get_data(data);
            for (int i = 0; i < gp.get_data_size(); i++)
                mem[gp.get_address() + i] = data[i];
            `uvm_info("TARGET", "Write complete", UVM_LOW)
        end else begin
            byte data[];
            data = new[gp.get_data_size()];
            for (int i = 0; i < gp.get_data_size(); i++)
                data[i] = mem.exists(gp.get_address() + i) ? 
                    mem[gp.get_address() + i] : 8'h0;
            gp.set_data(data);
            `uvm_info("TARGET", "Read complete", UVM_LOW)
        end
        
        gp.set_response_status(UVM_TLM_OK_RESPONSE);
    endtask
endclass

// ==========================================
// Environment
// ==========================================
class tlm2_basic_env extends uvm_env;
    `uvm_component_utils(tlm2_basic_env)
    
    tlm2_basic_initiator initiator;
    tlm2_basic_target target;
    
    virtual function void build_phase(uvm_phase phase);
        initiator = tlm2_basic_initiator::type_id::create("initiator", this);
        target = tlm2_basic_target::type_id::create("target", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        initiator.initiator_socket.connect(target.target_socket);
    endfunction
endclass

// ==========================================
// Test
// ==========================================
class tlm2_basic_test extends uvm_test;
    `uvm_component_utils(tlm2_basic_test)
    
    tlm2_basic_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        env = tlm2_basic_env::type_id::create("env", this);
    endfunction
endclass

module tb_tlm2_basic;
    initial begin
        run_test("tlm2_basic_test");
    end
endmodule
