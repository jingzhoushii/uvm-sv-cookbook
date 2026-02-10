# 01-build-phase - UVM 构建阶段

## 📚 知识点

- **build_phase** 执行时机和顺序
- **组件实例创建** (`create()` / `type_id::create()`)
- **config_db** 获取配置
- **工厂机制** (`uvm_component_utils`)

## 📖 背景知识

### 执行时机

```
仿真时间 0
    │
    ▼
build_phase (自底向上)
    ├── Driver.build_phase()
    ├── Monitor.build_phase()
    ├── Agent.build_phase()
    └── Env.build_phase()
    │
    ▼
connect_phase (自顶向下)
```

### 主要任务

1. **创建组件实例**
2. **获取配置**
3. **设置默认值**

## 📂 文件结构

```
01-build-phase/
├── README.md
├── Makefile
└── examples/
    └── 01_build_phase.sv
```

## 🚀 快速开始

```bash
cd 02-uvm-phases/01-build-phase
make
```

## 📝 关键代码

```systemverilog
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 创建组件
    driver = my_driver::type_id::create("driver", this);
    
    // 获取配置
    if (!uvm_config_db#(int)::get(this, "", "count", count)) begin
        `uvm_warning("NO_CFG", "Using default count=10")
        count = 10;
    end
endfunction
```

---

**快速导航**: [返回根目录](../../README.md) | [下一章节](../02-connect-phase)
