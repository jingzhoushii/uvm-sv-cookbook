# Virtual Class 在工厂中的应用

## 背景

UVM 1.2 增强了工厂机制，支持虚类的类型转换。

## 示例

```systemverilog
virtual class base_driver extends uvm_driver;
    pure virtual task drive(input bit [31:0] data);
endclass

class axi_driver extends base_driver;
    task drive(input bit [31:0] data);
        // AXI 驱动实现
    endtask
endclass
```

