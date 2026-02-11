# 🔌 Sockets & Interfaces

## Socket 类型

```mermaid
classDiagram
    class uvm_tlm_socket {
        <<abstract>>
        +base_addr
    }
    
    class uvm_tlmInitiatorSocket#(T) {
        +b_transport()
        +nb_transport_fw()
        +nb_transport_bw()
    }
    
    class uvm_tlmTargetSocket#(T) {
        +b_transport()
        +nb_transport_fw()
        +nb_transport_bw()
    }
    
    class uvm_tlm_multi_passthrough_socket#(T) {
        +bind()
        +add_binding()
    }
    
    uvm_tlm_socket <|-- uvm_tlmInitiatorSocket
    uvm_tlm_socket <|-- uvm_tlmTargetSocket
    uvm_tlm_socket <|-- uvm_tlm_multi_passthrough_socket
```

## 传输接口

### Blocking Transport

```systemverilog
// 接口定义
virtual task b_transport(
    T trans,
    uvm_tlm_time delay
);
```

### Non-blocking Transport

```systemverilog
// 前向接口
virtual function uvm_tlm_sync_e nb_transport_fw(
    T trans,
    ref PHASE phase,
    ref uvm_tlm_time delay
);

// 反向接口
virtual function uvm_tlm_sync_e nb_transport_bw(
    T trans,
    ref PHASE phase,
    ref uvm_tlm_time delay
);
```

## 完整示例：Initiator

```systemverilog
class tlm2_initiator extends uvm_component;
    `uvm_component_utils(tlm2_initiator)
    
    // Socket
    uvm_tlm_nb_transport_bw#(uvm_tlm_generic_payload)::type_id::create(
        "initiator_socket", this);
    
    // 配置
    bit [31:0] base_addr = 'h1000_0000;
    
    task run_phase(uvm_phase phase);
        uvm_tlm_generic_payload gp;
        uvm_tlm_time delay = new("delay", 1.0, UVM_PS);
        
        forever begin
            // 创建事务
            gp = new("gp");
            gp.set_command(UVM_TLM_WRITE_COMMAND);
            gp.set_address(base_addr + $urandom_range(0, 255));
            gp.set_data_size(64);
            
            byte data[];
            data = new[64];
            for (int i = 0; i < 64; i++)
                data[i] = $urandom();
            gp.set_data(data);
            
            // Blocking 传输
            `uvm_info("INIT", 
                $sformatf("Sending: addr=0x%0h", 
                    gp.get_address()), UVM_LOW)
            initiator_socket.b_transport(gp, delay);
            
            #100;
        end
    endtask
    
    // Non-blocking 回调
    virtual function uvm_tlm_sync_e nb_transport_bw(
        uvm_tlm_generic_payload gp,
        ref uvm_tlm_phase phase,
        ref uvm_tlm_time delay
    );
        `uvm_info("INIT_BW", 
            $sformatf("Response: addr=0x%0h status=%s", 
                gp.get_address(), gp.get_response_string()), UVM_LOW)
        return UVM_TLM_ACCEPTED;
    endfunction
endclass
```

## 完整示例：Target

```systemverilog
class tlm2_target extends uvm_component;
    `uvm_component_utils(tlm2_target)
    
    // Socket
    uvm_tlm_nb_transport_fw#(uvm_tlm_generic_payload)::export_type_id::create(
        "target_socket", this);
    
    // 内存
    bit [7:0] mem[bit [31:0]];
    
    // Blocking 传输
    virtual task b_transport(
        uvm_tlm_generic_payload gp,
        uvm_tlm_time delay
    );
        `uvm_info("TARGET", 
            $sformatf("Got: addr=0x%0h cmd=%s", 
                gp.get_address(), gp.get_command().name()), UVM_LOW)
        
        // 处理读写
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
    endfunction
    
    // Non-blocking 前向回调
    virtual function uvm_tlm_sync_e nb_transport_fw(
        uvm_tlm_generic_payload gp,
        ref uvm_tlm_phase phase,
        ref uvm_tlm_time delay
    );
        `uvm_info("TARGET_FW", 
            $sformatf("NB FW: addr=0x%0h", gp.get_address()), UVM_LOW)
        
        // 处理事务
        b_transport(gp, delay);
        
        return UVM_TLM_ACCEPTED;
    endfunction
endclass
```

## Multi-Passthrough Socket

```systemverilog
class router extends uvm_component;
    `uvm_component_utils(router)
    
    // 多个目标
    uvm_tlm_multi_passthrough_socket#(uvm_tlm_generic_payload) 
        socket[4];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        for (int i = 0; i < 4; i++)
            socket[i] = new($sformatf("socket[%0d]", i), this, i);
    endfunction
    
    virtual function void b_transport(
        uvm_tlm_generic_payload gp,
        uvm_tlm_time delay
    );
        // 路由到正确目标
        int idx = gp.get_address()[31:28];
        socket[idx].b_transport(gp, delay);
    endfunction
endclass
```

## Phase 定义

```systemverilog
typedef enum {
    UNINITIALIZED_PHASE,
    BEGIN_REQ,
    END_REQ,
    BEGIN_RESP,
    END_RESP
} uvm_tlm_phase;
```

## 同步状态

```systemverilog
typedef enum {
    UVM_TLM_ACCEPTED,
    UVM_TLM_UPDATED,
    UVM_TLM_COMPLETED
} uvm_tlm_sync_e;
```

## 最佳实践

| 实践 | 说明 |
|------|------|
| 选择合适模式 | 简单用 blocking |
| 处理 phase | 正确管理 phase 转换 |
| 时间延迟 | 传递延迟信息 |
| 错误处理 | 检查响应状态 |

## 进阶阅读

- [DMI](04-dmi/)
- [Quantum Keeper](05-quantum-keeper/)
