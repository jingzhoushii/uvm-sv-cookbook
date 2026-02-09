# 贡献指南

感谢你考虑为 UVM-SV Cookbook 贡献代码!

## 添加新示例的步骤

### 1. 创建目录结构

```
cd 01-sv-fundamentals/01-data-types/
touch README.md Makefile
mkdir -p dut tb test
```

### 2. 每个文件的标准结构

#### README.md

```markdown
# 01-data-types

## 知识点

- SystemVerilog 数据类型
- 2态 vs 4态
- 类型转换

## 关键代码

```systemverilog
logic [7:0] data;
bit [7:0] counter;
```

## 运行

```bash
make
```

## 思考题

1. 为什么 `logic` 初始值是 X?
2. `bit` 和 `logic` 有什么区别?
```

#### Makefile

```makefile
# 支持 VCS, Xcelium, Questa

SIM ?= vcs

all: compile run

compile:
ifeq ($(SIM),vcs)
	vcs -sverilog +v2k -ntb_opts uvm -l comp.log
else ifeq ($(SIM),xrun)
	xrun -sv -uvm -l comp.log
else ifeq ($(SIM),vsim)
	vsim -sv -UVM_NO_DEPRECATED -l comp.log
endif

run:
ifeq ($(SIM),vcs)
	./simv -l run.log
else ifeq ($(SIM),xrun)
	xrun -R
else ifeq ($(SIM),vsim)
	vsim -c -do "run -all; quit"
endif

waves:
	gtkwave dump.vcd

clean:
	rm -f *.log *.vcd simv* DVEfiles/
```

### 3. 代码规范

#### SystemVerilog 风格

```systemverilog
// ✅ 推荐
class my_driver extends uvm_driver#(my_txn);
    `uvm_component_utils(my_driver)
    
    virtual my_if vif;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Build phase", UVM_LOW)
    endfunction
endclass

// ❌ 不推荐
class bad_driver;
    virtual my_if vif;  // 缺少 utils
endclass
```

#### 注释规范

```systemverilog
// ============================================================
// Class: my_driver
// Description: 驱动DUT接口
// ============================================================

// 获取虚接口
if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
    `uvm_fatal("NO_VIF", "无法获取虚接口")
end
```

### 4. 提交 Pull Request

```bash
git checkout -b feature/add-axi-example
git add .
git commit -m "feat: add AXI4-Lite example"
git push origin feature/add-axi-example
```

## 检查清单

- [ ] README.md 包含知识点说明
- [ ] Makefile 支持多仿真器
- [ ] 代码使用 `uvm_component_utils
- [ ] 关键代码有注释
- [ ] 测试通过

## 代码风格

参考 [Google SystemVerilog Style Guide](https://google.github.io/styleguide/systemverilog.html)
