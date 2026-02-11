// ============================================================================
// TLM 2.0 DMI Example - 直接内存访问示例
// ============================================================================

`include "uvm_macros.svh"

typedef uvm_tlm_generic_payload gp_t;
typedef uvm_tlm_time#(1, UVM_PS) tlm_time_t;
typedef uvm_tlm_dmi_handle dmi_handle_t;

// ==========================================
// DMI Target
// ==========================================
class tlm2_dmi_target extends uvm_component;
    `uvm_component_utils(tlm2_dmi_target)
    
    uvm_tlm_b_transport_bw#(gp_t)::export_type_id::create("target_socket", this);
    
    // 内存
    bit [7:0] mem[bit [31:0]];
    dmi_handle_t dmi;
    
    virtual task b_transport(gp_t gp, tlm_time_t delay);
        // 启用 DMI
        if (!gp.is_dmi_allowed()) begin
            `uvm_info("TARGET", "Enabling DMI", UVM_LOW)
            gp.set_dmi_allowed(1);
            
            // 配置 DMI
            dmi.set_read_ptr(mem);
            dmi.set_write_ptr(mem);
            dmi.set_start_address(0);
            dmi.set_end_address('hFFFF_FFFF);
            dmi.set_read_latency(1);
            dmi.set_write_latency(1);
            dmi.set_granted_latency(0);
            
            return;
        end
        
        // DMI 访问
        if (gp.get_command() == UVM_TLM_WRITE_COMMAND) begin
            byte data[];
            gp.get_data(data);
            for (int i = 0; i < gp.get_data_size(); i++)
                mem[gp.get_address() + i] = data[i];
        end else begin
            byte data[];
            data = new[gp.get_data_size()];
            for (int i = 0; i < gp.get_data_size(); i++)
                data[i] = mem.exists(gp.get_address() + i) ? 
                    mem[gp.get_address() + i] : 8'h0;
            gp.set_data(data);
        end
        
        gp.set_response_status(UVM_TLM_OK_RESPONSE);
    endtask
endclass

// ==========================================
// DMI Initiator
// ==========================================
class tlm2_dmi_initiator extends uvm_component;
    `uvm_component_utils(tlm2_dmi_initiator)
    
    uvm_tlm_b_transport_fw#(gp_t)::type_id::create("initiator_socket", this);
    
    bit [31:0] base_addr = 'h1000_0000;
    int dmi_access_count = 0;
    int tlm_access_count = 0;
    
    task run_phase(uvm_phase phase);
        gp_t gp;
        tlm_time_t delay = new("delay", 1.0, UVM_NS);
        
        forever begin
            gp = new("gp");
            gp.set_command(UVM_TLM_READ_COMMAND);
            gp.set_address(base_addr + $urandom_range(0, 255));
            gp.set_data_size(64);
            
            if (gp.is_dmi_allowed()) begin
                // DMI 访问
                dmi_access_count++;
                `uvm_info("DMI", 
                    $sformatf("DMI access #%0d: addr=0x%0h", 
                        dmi_access_count, gp.get_address()), UVM_LOW)
            end else begin
                // TLM 事务访问
                tlm_access_count++;
                `uvm_info("TLM", 
                    $sformatf("TLM access #%0d: addr=0x%0h", 
                        tlm_access_count, gp.get_address()), UVM_LOW)
                initiator_socket.b_transport(gp, delay);
            end
            
            #10;
        end
    endtask
endclass

// ==========================================
// Environment
// ==========================================
class tlm2_dmi_env extends uvm_env;
    `uvm_component_utils(tlm2_dmi_env)
    
    tlm2_dmi_initiator initiator;
    tlm2_dmi_target target;
    
    virtual function void build_phase(uvm_phase phase);
        initiator = tlm2_dmi_initiator::type_id::create("initiator", this);
        target = tlm2_dmi_target::type_id::create("target", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        initiator.initiator_socket.connect(target.target_socket);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("ENV", 
            $sformatf("DMI accesses: %0d, TLM accesses: %0d", 
                initiator.dmi_access_count, initiator.tlm_access_count), 
            UVM_LOW)
    endfunction
endclass

// ==========================================
// Test
// ==========================================
class tlm2_dmi_test extends uvm_test;
    `uvm_component_utils(tlm2_dmi_test)
    
    tlm2_dmi_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        env = tlm2_dmi_env::type_id::create("env", this);
    endfunction
endclass

module tb_tlm2_dmi;
    initial begin
        run_test("tlm2_dmi_test");
    end
endmodule
