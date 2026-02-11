# 🏗️ UVM 测试平台架构

## 整体架构

```mermaid
graph TB
    subgraph "Test Layer"
        T[Test]
    end
    
    subgraph "Virtual Sequence Layer"
        VS[Virtual Sequence]
    end
    
    subgraph "Environment Layer"
        ENV[UVM Environment]
        VSEQ[Virtual Sequencer]
        SB[Scoreboard]
        COV[Coverage]
        REF[Reference Model]
    end
    
    subgraph "Agent Layer"
        AG[Bus Agent]
        UA[UART Agent]
        DA[DMA Agent]
    end
    
    subgraph "DUT Layer"
        DUT[Mini SoC]
    end
    
    T --> VS
    VS --> VSEQ
    VSEQ --> AG
    VSEQ --> UA
    VSEQ --> DA
    AG --> DUT
    UA --> DUT
    DA --> DUT
    AG --> SB
    AG --> COV
    AG --> REF
    REF --> SB
```

## 组件详解

### 1. Test Layer

```mermaid
classDiagram
    class base_test {
        +build_phase()
        +connect_phase()
        +run_phase()
        #cfg: env_cfg
    }
    
    class smoke_test {
        +body()
    }
    
    class stress_test {
        +body()
    }
    
    base_test <|-- smoke_test
    base_test <|-- stress_test
```

### 2. Virtual Sequence Layer

```mermaid
stateDiagram-v2
    [*] --> PowerOn
    PowerOn --> Configure: power_on_vseq
    Configure --> Traffic: mixed_io_vseq
    Traffic --> Stress: stress_vseq
    Stress --> Chaos: random_vseq
    Chaos --> [*]
```

### 3. Communication Flow

```mermaid
sequenceDiagram
    participant T as Test
    participant VS as Virtual Seq
    participant SQ as Sequencer
    participant DR as Driver
    participant MON as Monitor
    participant SB as Scoreboard
    
    T->>VS: start()
    VS->>SQ: start()
    SQ->>DR: get_next_item()
    DR->>DUT: drive(transaction)
    DUT-->>DR: response
    DR->>SQ: item_done()
    MON->>SB: write(transaction)
```

## 目录结构

```
projects/mini_soc/tb/
├── agent/
│   ├── bus_agent/
│   │   ├── bus_driver.sv
│   │   ├── bus_monitor.sv
│   │   └── bus_sequencer.sv
│   ├── uart_agent/
│   └── dma_agent/
├── env/
│   ├── mini_soc_env.sv
│   └── mini_soc_env_cfg.sv
├── virt_seq/
│   ├── base_vseq.sv
│   ├── boot_vseq.sv
│   └── stress_vseq.sv
└── test/
    ├── base_test.sv
    ├── smoke_test.sv
    └── stress_test.sv
```

## 在线仿真

点击下方运行 UVM 架构示例：

[:fontawesome-solid-play: Run on EDA Playground](https://edaplayground.com/){ .md-button .md-button--primary }

## 相关章节

- [UVM 阶段](02-uvm-phases/01-phases.md)
- [TLM 通信](05-tlm-communication/01-tlm-basics.md)
- [序列设计](03-sequences/01-sequences.md)
