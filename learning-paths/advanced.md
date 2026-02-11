# 🏗️ 高级路径（6周）

## 目标

掌握低功耗验证、中断验证、形式验证、性能优化，能处理复杂验证场景。

## 预计时间

- **总时长**: 约 60-90 小时
- **每周**: 10-15 小时
- **每日**: 1-2 小时

## 前置要求

| 要求 | 说明 |
|------|------|
| 中级路径完成 | 完整 UVM 知识体系 |
| 项目经验 | 至少 1 个完整项目 |
| 脚本能力 | Python/Perl 基础 |

## 学习顺序

### Week 1-2: 低功耗验证 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 1-3 | [11-low-power/01-power-domains](../11-low-power/01-power-domains/) | 6h | 电源域、状态 |
| Day 4-6 | [11-low-power/02-power-sequences](../11-low-power/02-power-sequences/) | 6h | 功耗序列 |
| Day 7-10 | [11-low-power/03-power-coverage](../11-low-power/03-power-coverage/) | 8h | 功耗覆盖率 |
| Day 11-14 | [Mini SoC 低功耗扩展](../projects/mini_soc/low_power/) | 8h | 项目实践 |

### Week 3-4: 中断验证 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 15-17 | [12-interrupt/01-interrupt-basics](../12-interrupt/01-interrupt-basics/) | 6h | 中断机制 |
| Day 18-20 | [12-interrupt/02-interrupt-sequences](../12-interrupt/02-interrupt-sequences/) | 6h | 中断序列 |
| Day 21-24 | [12-interrupt/03-interrupt-coverage](../12-interrupt/03-interrupt-coverage/) | 8h | 中断覆盖率 |
| Day 25-28 | [Mini SoC 中断扩展](../projects/mini_soc/interrupt/) | 8h | 项目实践 |

### Week 5: 形式验证 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 29-31 | [13-formal-verification/01-formal-basics](../13-formal-verification/01-formal-basics/) | 6h | 形式验证基础 |
| Day 32-33 | [13-formal-verification/02-assertions](../13-formal-verification/02-assertions/) | 4h | SVA 断言 |
| Day 34-35 | [13-formal-verification/03-formal-uvm](../13-formal-verification/03-formal-uvm/) | 4h | UVM + 形式验证 |

### Week 6: 性能优化 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 36-38 | [14-performance/01-optimization-basics](../14-performance/01-optimization-basics/) | 6h | 优化基础 |
| Day 39-40 | [14-performance/02-sequence-opt](../14-performance/02-sequence-opt/) | 4h | 序列优化 |
| Day 41-42 | [14-performance/03-coverage-opt](../14-performance/03-coverage-opt/) | 4h | 覆盖率优化 |

## 核心知识点

### 低功耗验证

```systemverilog
// 电源状态
typedef enum {ON, OFF, RETENTION} power_state_e;

// 低功耗序列
class power_seq extends uvm_sequence;
    virtual task body();
        // 关闭电源
        `uvm_do_with(power_ctrl, {state == OFF;})
        
        // 等待恢复
        #100;
        
        // 恢复电源
        `uvm_do_with(power_ctrl, {state == ON;})
    endtask
endclass
```

### 中断验证

```systemverilog
// 中断序列
class interrupt_seq extends uvm_sequence;
    rand int interrupt_num;
    
    virtual task body();
        // 触发中断
        `uvm_do_with(interrupt_reg, {
            enable == 1;
            num == interrupt_num;
        })
        
        // 等待中断处理
        wait(irq_handler.irq_asserted[interrupt_num]);
        
        // 清除中断
        `uvm_do(clear_intr);
    endtask
endclass
```

### 形式验证

```systemverilog
// SVA 断言
property p_addr_range;
    @(posedge clk) valid |-> (addr inside {[0:'h1000]});
endproperty

a_addr_range: assert property(p_addr_range);

// 形式验证覆盖
cover property(p_addr_range);
```

## 实践项目

1. **低功耗扩展**: 为 Mini SoC 添加电源管理
2. **中断扩展**: 实现中断控制器验证
3. **性能分析**: 优化验证平台性能

## 检查清单

- [ ] 掌握低功耗验证方法
- [ ] 能验证中断场景
- [ ] 理解形式验证基础
- [ ] 能优化验证性能

## 下一步

完成高级路径后，进入 [专家路径](expert.md)。

## 资源

- [低功耗验证指南](https://verificationacademy.com/low-power/)
- [形式验证资源](https://verificationacademy.com/formal/)
- [SVA 教程](https://verificationacademy.com/sva/)
