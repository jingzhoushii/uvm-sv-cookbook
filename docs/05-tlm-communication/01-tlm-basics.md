# 🔗 TLM 通信基础

## TLM 端口类型

```mermaid
graph LR
    subgraph "Analysis Ports"
        AP[analysis_port]
        IMP[analysis_imp]
    end
    
    subgraph "Blocking Ports"
        BP[blocking_get_port]
        BP2[blocking_put_port]
    end
    
    subgraph "Non-Blocking"
        NB[nb_get_port]
        NB2[nb_put_port]
    end
    
    AP --> IMP
    BP --> BP2
    NB --> NB2
```

## 时序图：事务传递

```mermaid
sequenceDiagram
    participant D as Driver
    participant S as Sequencer
    participant M as Monitor
    participant SB as Scoreboard
    
    Note over D,S: Sequence Item Flow
    S->>D: get_next_item(item)
    D->>D: process_item(item)
    D->>S: item_done(item)
    
    Note over M,SB: Transaction Analysis
    M->>SB: write(transaction)
    SB->>SB: compare()
```

## 代码示例

```systemverilog
// Monitor 发送事务
class bus_monitor extends uvm_monitor;
    uvm_analysis_port#(bus_trans) ap;
    
    virtual function void write(bus_trans t);
        `uvm_info("MON", $sformatf("Saw transaction: %s", t.convert2str()), UVM_LOW)
        ap.write(t);
    endfunction
endclass

// Scoreboard 接收事务
class soc_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp#(bus_trans, soc_scoreboard) bus_in;
    
    virtual function void write(bus_trans t);
        expected_q.push_back(t);
        compare();
    endfunction
endclass
```

## 连接关系

```mermaid
graph TB
    MON[Monitor]
    EXP[analysis_export]
    SB[Scoreboard]
    COV[Coverage]
    REF[Ref Model]
    
    MON --> EXP
    EXP ==> SB
    EXP ==> COV
    EXP ==> REF
```

## 在线仿真

运行 TLM 通信示例：

[:fontawesome-solid-play: EDA Playground](https://edaplayground.com/){ .md-button }

## 进阶阅读

- [Analysis Ports 详解](02-analysis-ports.md)
- [TLM FIFO](03-tlm-fifo.md)
