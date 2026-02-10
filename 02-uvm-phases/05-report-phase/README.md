# 05-report-phase - UVM 报告阶段

## 📚 知识点

- **report_phase** 时机
- **`uvm_error/warning/info** 统计
- **测试结果汇总**
- **文件输出**

## 📖 背景知识

`run_phase` 完成后立即执行，用于：

1. 汇总测试结果
2. 生成测试报告
3. 检查测试通过/失败

## 📝 关键代码

```systemverilog
virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    if (severity_count[UVM_ERROR] == 0) begin
        `uvm_info("TEST_PASS", "All tests passed!", UVM_LOW)
    end else begin
        `uvm_error("TEST_FAIL", 
            $sformatf("Found %0d errors", severity_count[UVM_ERROR]))
    end
endfunction
```

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../04-run-phase) | [下一章节](../06-final-phase)
