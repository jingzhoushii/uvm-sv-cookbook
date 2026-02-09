# 01-power-domains-basics - 电源域基础

## 知识点

- 电源域定义
- 隔离单元
- 保持寄存器

## 运行

```bash
cd 11-low-power-verification/01-power-domains-basics && make
```

## UPF 文件

```upf
create_power_domain TOP
create_power_domain DOMAIN_A -supply {supply_vss}
```
