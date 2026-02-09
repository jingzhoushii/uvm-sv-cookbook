# 03-uvm_agent - UVM Agent

## 知识点

UVM Agent 是 Driver、Monitor、Sequencer 的容器：

```systemverilog
class bus_agent extends uvm_agent;
    `uvm_component_utils(bus_agent)
    
    bus_driver    driver;     // 仅 ACTIVE
    bus_monitor   monitor;    // 总是需要
    bus_sequencer sequencer; // 仅 ACTIVE
    
    uvm_active_passive_enum is_active;
    
    virtual function void build_phase(uvm_phase phase);
        monitor = bus_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            driver = bus_driver::type_id::create("driver", this);
            sequencer = bus_sequencer::type_id::create("sequencer", this);
        end
    endfunction
endclass
```

## 运行

```bash
make
```
